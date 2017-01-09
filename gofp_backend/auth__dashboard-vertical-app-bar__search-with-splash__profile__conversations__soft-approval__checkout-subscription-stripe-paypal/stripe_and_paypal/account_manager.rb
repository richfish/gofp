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
    new_amount = order.participant_amount_cents
    account.total_earnings += new_amount
    update_balance
  end

  def subtract_capture
    minus_amount = order.participant_amount_cents
    account.total_earnings -= minus_amount
    update_balance
  end

  def issue_refund
    refund_amount = refund.amount_cents_from_provider
    account.total_refunds += refund_amount
    update_balance
  end

  private

  def update_balance
    earnings = account.total_earnings
    refunds = account.total_refunds
    account.balance = earnings - refunds
    account.save
  end
end