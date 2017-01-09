module MoneyHelper

  def pending_payout_amount
    number_to_currency(pending_payout_amount_raw/100)
  end

  def pending_payout_amount_raw
    confirmed_cents   = current_user.bootcamps.confirmed.sum(:amount_cents)
    unconfirmed_cents = current_user.bootcamps.unconfirmed.sum(:amount_cents)  #if have 1 or more applications, just count 1 applications cents
    confirmed_cents + unconfirmed_cents
  end

  def paid_out_to_date
    paid_out_raw = total_earnings_raw - pending_payout_amount_raw
    number_to_currency(paid_out_raw/100, precision: 2)
  end

  def total_earnings
    number_to_currency(total_earnings_raw/100)
  end

  def total_earnings_raw
    current_user.account.total_earnings
  end

  def total_refunds
    number_to_currency(current_user.account.total_refunds)
  end
end
