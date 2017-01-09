#################################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#  PLEASE KEEP FACTORIES IN ALPHABETICAL ORDER
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#################################################
FactoryGirl.define do

  factory :contact_message do
    email "test@test.com"
    subject "test123"
    message "this123"
  end

end