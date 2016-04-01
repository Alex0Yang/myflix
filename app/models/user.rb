class User < ActiveRecord::Base
  has_secure_password validations: false

  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email
  has_many :comments, -> { order 'created_at desc' }
  has_many :queue_items, -> { order :position }

  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: :leader_id

  def normalize_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attribute(:position, index+1)
    end
  end

  def queue_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def comments_count
    comments.count
  end

  def queue_items_count
    queue_items.count
  end

  def can_follow?(leader)
   ! ( following_relationships.map(&:leader).include?(leader) || self == leader )
  end
end
