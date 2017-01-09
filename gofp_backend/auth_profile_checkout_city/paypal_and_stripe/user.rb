class User < ActiveRecord::Base

  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  after_create ->{ AccountManager.allocate_account(self) }

  has_one :account

end
