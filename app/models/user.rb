class User < ActiveRecord::Base
  has_secure_password validations: false

  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email
  has_many :comments
  has_many :queue_items, -> { order :position }

  def normalize_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attribute(:position, index+1)
    end
  end

  def queue_video?(video)
    queue_items.map(&:video).include?(video)
  end
end
