class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :position, only_integer: true

  validates_presence_of :video, :user

  delegate :category, to: :video
  delegate :title, to: :video, prefix: true
  delegate :name, to: :category, prefix: true

  def rating
    comment = Comment.where(user: user, video: video).first
    comment.rate if comment
  end

  def self.update_queue(params)
    params.each do |key, value|
      item = QueueItem.find(key)
      item.update!(position: value["position"])
    end
  end

end
