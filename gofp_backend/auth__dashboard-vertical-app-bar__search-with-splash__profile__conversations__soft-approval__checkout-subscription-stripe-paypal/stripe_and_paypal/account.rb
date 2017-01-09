class Account < ActiveRecord::Base
  belongs_to :user
  has_many :orders
  has_many :refunds
end
