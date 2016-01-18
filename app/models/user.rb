class User < ActiveRecord::Base
  has_secure_password validations: false

  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email
  has_many :comments
  has_many :queue_items
end
