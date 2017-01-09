#################################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#  PLEASE KEEP FACTORIES IN ALPHABETICAL ORDER
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#################################################
FactoryGirl.define do

  factory :order do
    email "test@order.com"
    euid "abc_xyz_123_yada_yada"
    first_name "Shopper"
    last_name "Customer"
    amount_cents 128000
    fee_cents 8000
    participant_amount_cents 120000
    captured false
    capture_rejected false
    admin_auth_voided false
    trait :paypal do
      paypal true
      stripe false
      paypal_identifier "abc123_paypal"
      paypal_payer_id "xyz123_paypal"
    end
    trait :stripe do
      paypal false
      stripe true
      paypal_identifier nil
      paypal_payer_id nil
      stripe_token "xyz123_stripe"
      stripe_customer_hash "abc123_stripe"
    end
  end

  factory :user do
    sequence(:email){|n| "test#{n}@littleboot.com"}
    password "12345678"
    city "San Francisco Bay Area"
  end

end
