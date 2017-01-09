class AccountManager

  attr_accessor :order, :account, :refund

  def self.allocate_account(user)
    Account.create(user: user)
  end

  def initialize(order_or_refund)
    #TODO Subclass
    if order_or_refund.is_a?(Order)
      @order = order_or_refund
      @account = order.account
    elsif order_or_refund.is_a?(Refund)
      @refund = order_or_refund
      @account = refund.account
    else
      raise "error not order or refund"
    end
  end

  def update_earnings
    #CUSTOMIZE THIS
    #new_amount = order.booking.amount_cents.to_i #careful, booking has amount_cents raw without fee (the amount provider earns), order has amount_cents with the fee added (amount customer paid)
    new_amount = order.amount_cents.to_i
    account.total_earnings += new_amount
    update_balance(new_amount)
  end

  def issue_refund
    refund_amount = refund.amount_cents
    account.total_refunds += refund_amount
    update_balance(refund_amount)
  end

  private

  def update_balance(new_amount)
    earnings = account.total_earnings
    refunds = account.total_refunds
    account.balance = earnings - refunds
    account.save
  end
end