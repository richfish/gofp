class PaypalManager

  def self.paypal_url(booking)
    #CUSTOMIZE
    amount = 120#BookingFeeManager.new(booking).total_amount_for_paypal
    name = "Booking with boilerplate"
    return_url = "/"
    business = "payments@boilerplate.com"
    values = {
      :business => business,
      :cmd => '_cart',
      :upload => 1,
      :notify_url => PaypalIpn.notify_url,
      :return => "#{PaypalIpn.return_url}?euid=#{booking.ipn_key rescue 1231231231}",
      :cancel_return => "#{PaypalIpn.cancel_url}/users/1123/bookings/22232/orders/new"
    }
    values.merge!({
      "amount_1" => amount,
      "item_name_1" => name,
      "custom" => 132412341234
     })
    PaypalManager.paypal_base_url + values.to_query
  end

  def self.paypal_base_url
    if Rails.env.development? || Rails.env.test? || Rails.env.production?
      "https://www.sandbox.paypal.com/cgi-bin/webscr?"
    else
      "https://www.paypal.com/cgi-bin/webscr?"
    end
  end

  class IpnHandler
    include PaypalIpn
    attr_accessor :ipn_params

    def initialize(ipn_params)
      @ipn_params = ipn_params
      create_record_of_ipn_notification
    end

    def correct_intended_merchant?
      receiver_email.in? PaypalIpn.account_emails
    end

    def not_duplicate_ipn?
      !IpnNotification.where(txn_id: txn_id, payment_status: payment_status).exists?
    end

    def paid_correct_amount?(booking)
      #CUSTOMIZE
      #mc_gross.to_f == BookingFeeManager.new(booking).total_amount_for_paypal.to_f
    end

    private

    def create_record_of_ipn_notification
      if not_duplicate_ipn?
        ipn_db_columns = IpnNotification.column_names.dup
        ipn_record_keys = ipn_db_columns.delete_if{ |key, _| key.to_sym.in? [:id, :created_at, :updated_at] }
        ipn_record_hash = ipn_params.select{|x| x.in? ipn_record_keys }
        IpnNotification.create(ipn_record_hash.permit!)
      else
        raise Exceptions::Paypal::DuplicateIpn
      end
    end
  end

end

