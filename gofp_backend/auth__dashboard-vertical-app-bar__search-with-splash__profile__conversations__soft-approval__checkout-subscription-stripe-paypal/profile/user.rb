class User < ActiveRecord::Base

  devise :database_authenticatable, :async, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :orders
  has_one :profile
  has_one :avatar, class_name: 'Asset', :as => :owner, dependent: :destroy  

  def first_name
    self.orders.present? ? self.orders.first.first_name : nil
  end

  def last_name
    self.orders.present? ? self.orders.first.last_name : nil
  end

  def full_name
    [first_name, last_name].join(" ").squish.presence
  end

  def existing_customer?
    self.orders.active.present?
  end

end
