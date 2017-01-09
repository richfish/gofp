class OrdersController < ApplicationController
  protect_from_forgery except: [:paypal_ipn]

  #before_filter :check_expired, only: :new
  #before_filter ->{ load_resource(:artist, :user_id) {|x| User.artists.published.find(x)} }, except: [:paypal_ipn, :show_paypal_redirect]
  #before_filter ->{ load_resource(:booking) {|x| @artist.artist_bookings.unscoped.find(x)} }, except: [:paypal_ipn, :show_paypal_redirect]
  #^using #unscoped for expired bookings edge case when submiting payment info - i.e., let it go through
  attr_accessor :email, :first_name, :last_name

  #by Convention (mine) this action represents the checkout page
  #sample data consumed by #new
  Booking = Struct.new(:local_time, :month, :day, :day_of_week, :num_hours, :customer_booking_name, :note_to_provider)
  def new
    @booking = Booking.new("12:00 PM", "March", "23", "Saturday", 4, "Linda Breezeworthy", "I look forward to meeting up.")
  end

  def create
    #return unless (set_email_attributes && set_name_attributes)
    @first_name, @last_name = params[:first_name], params[:last_name]
    stripe_token = params[:stripeToken]
    total_order_amount = ADMINISTRATIVE_SETTINGS[:base_charge]

    customer = if current_user.existing_customer?
      stripe_manager = StripeCcManager.new(current_user)
      stripe_manager.add_another_subscription!
      stripe_manager.stripe_cus
    else
      Stripe::Customer.create(
        :email => @email,
        :plan => 'monkey_subscription',
        :card  => stripe_token
      )
    end
    # charge = Stripe::Charge.create(
    #   :customer    => customer.id,
    #   :amount      => total_order_amount,
    #   :description => "Monkey",
    #   :currency    => 'usd'
    # )
    @order = Order.create(user_id: current_user.id, stripe_customer_hash: customer.id, stripe_token: stripe_token, amount_cents: total_order_amount, email: @email, first_name: @first_name, last_name: @last_name)
    flash[:notice] = "monkey monkey"
    redirect_to user_path
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
  end

  # def returning_stripe
  #   customer_id = current_user.stripe_customer_id
  #   raise Exceptions::NoFoundStripeOrder unless customer_id
  #   returning_customer = Stripe::Customer.retrieve(customer_id)
  #   booking_manager    = BookingFeeManager.new(@booking)
  #   fee_amount         = booking_manager.fee
  #   total_order_amount = booking_manager.total_amount.to_i
  #
  #   charge = Stripe::Charge.create(
  #     :customer    => returning_customer.id,
  #     :amount      => total_order_amount,
  #     :description => "Monkey",
  #     :currency    => 'usd'
  #   )
  #   @order = Order.create(booking: @booking, stripe: true, paypal: false, stripe_customer_hash: returning_customer.id, stripe_token: "returning_customer",
  #     amount_cents: total_order_amount, fee_cents: fee_amount, email: current_user.email, first_name: current_user.first_name, last_name: current_user.last_name)
  #
  #   redirect_to user_booking_order_path(user_id: @artist.id, booking_id: @booking.id, id: @order.id)
  # rescue Stripe::CardError => e
  #   flash[:error] = e.message
  #   render :new
  # end

  def paypal_ipn
    #https://developer.paypal.com/webapps/developer/docs/classic/ipn/integration-guide/IPNIntro/
    #This can't break or IPN will be sent repeadetly. Hence head :ok

    ipn_handler = PaypalManager::IpnHandler.new(params)
    booking = Booking.unscoped.find_by_ipn_key(ipn_handler.custom)  #edge case expired booking
    raise Exceptions::Paypal::CantFindBooking unless booking
    #booking expired, revive booking?/ check for expired?

    return unless ipn_handler.payment_completed? #do nothing here
    raise Exceptions::Paypal::InvalidIpn unless ipn_handler.verify_ipn!
    raise Exceptions::Paypal::WrongMerchant unless ipn_handler.correct_intended_merchant?
    raise Exceptions::Paypal::IncorrectAmountPaid unless ipn_handler.paid_correct_amount?(booking) #notify ADMIN

    booking_manager    = BookingFeeManager.new(booking)
    account            = booking.artist.account
    fee_amount         = booking_manager.fee
    total_order_amount = booking_manager.total_amount
    email              = ipn_handler.payer_email
    payer_id           = ipn_handler.payer_id
    first_name         = ipn_handler.first_name
    last_name          = ipn_handler.last_name
    paypal_identifier  = ipn_handler.txn_id

    order = Order.create(booking: booking, stripe: false, paypal: true, paypal_payer_id: payer_id, paypal_identifier: paypal_identifier,
          amount_cents: total_order_amount, fee_cents: fee_amount, email: email, first_name: first_name, last_name: last_name)

    head :ok
  rescue Exceptions::Paypal::IncorrectAmountPaid
    puts "------------------PAYPAL INCORRECT AMOUNT------------------"
    puts "-------------#{params.inspect}------------"
    puts "-------------#{booking.inspect}-----------"
    AdminMailer.delay.paypal_incorrect_amount(booking, params)
  rescue => e
    puts "------------------PAYPAL IPN RELATED ERROR-----------------"
    puts e.inspect
    AdminMailer.delay.paypal_ipn_related_error(booking, params)
    head :ok
  end

  #by Convention (mine) this is the confirmation/ post checkout page
  def show
    @order = Order.find(params[:id])
    if params[:euid]
      return redirect_to root_path unless verify_security_key(@order.order_key)
    end
  end

  def paypal_confirmation
    booking = Booking.find_by_ipn_key(params[:euid])
    raise Exceptions::Paypal::CantFindBookingOnReturn unless booking
    return redirect_to user_booking_order_path(user_id: booking.artist.id, booking_id: booking.id, id: booking.order.id)
  end

  def stripe_webhook
  #customize behavior if desired
  #stripe_customer = StripeCcManager.retrieve_customer_from_webhook(params)
  end


  private

  def validate_and_set_email_and_name_attributes
    if current_user && current_user.is_customer?
      @email = current_user.email
      @first_name = current_user.proto_user.first_name
      @last_name = current_user.proto_user.last_name
    else
      return false unless (set_email_attributes && set_name_attributes)
    end
    true
  end

  def set_email_attributes
    @email, email_confirm = params[:email], params[:email_confirm]
    if @email.blank? || email_confirm.blank?
      flash[:error] = "Must submit your email"
      render :new
      return false
    end
    if @email != email_confirm
      flash[:error] = "Emails don't match"
      render :new
      return false
    end
    unless (/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i).match(@email).present?
      flash[:error] = "Email is invalid"
      render :new
      return false
    end
    true
  end

  def set_name_attributes
    @first_name, @last_name = params[:first_name], params[:last_name]
    if @first_name.blank? || @last_name.blank?
      flash[:error] = "We need your name."
      render :new
      return false
    end
    true
  end


end
