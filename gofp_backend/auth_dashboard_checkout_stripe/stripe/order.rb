class Order < ActiveRecord::Base
  before_create ->{ self.euid = UUID.generate }

end
