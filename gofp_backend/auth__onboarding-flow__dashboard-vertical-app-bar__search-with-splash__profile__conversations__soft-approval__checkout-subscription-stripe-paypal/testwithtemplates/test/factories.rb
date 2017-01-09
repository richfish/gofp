#################################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#  PLEASE KEEP FACTORIES IN ALPHABETICAL ORDER
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#################################################
FactoryGirl.define do
  factory :admin_user do
    
  end
  factory :user do
    
  end
  factory :site_subscription do
    email "MyString"
  end

  factory :contact_message do
    email "test@test.com"
    subject "test123"
    message "this123"
  end

end