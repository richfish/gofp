module PaypalIpn

  IPN_ATTRS = %w( payment_status payment_date payer_email payer_id receiver_email txn_id first_name
                  last_name mc_gross payment_gross mc_fee mc_currency custom )
  STATUS_COMPLETE = :completed.to_s.capitalize

  mattr_accessor :account_emails, :notify_url, :return_url, :cancel_url

  def self.setup
    yield self
  end

  IPN_ATTRS.each do |ipn_attr|
    define_method ipn_attr.to_sym do
      ipn_params[ipn_attr]
    end
  end

  def verify_ipn!
    request_uri = URI(PaypalManager.paypal_base_url)
    request_uri.scheme = "https" # force https
    response = RestClient.post(request_uri.to_s, ipn_params.reverse_merge("cmd"=>"_notify-validate") )
    response.body == "VERIFIED" #only other option is "INVALID"
  end

  def payment_completed?
    payment_status == STATUS_COMPLETE
  end

  def customer_address(delimeter = "\n")
    [
      customer_address_name,
      customer_address_street,
      customer_address_city,
      customer_address_state,
      customer_address_country + " " + customer_address_zip,
    ].join(delimeter)
  end

end
