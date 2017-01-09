class User < ActiveRecord::Base

  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

end
