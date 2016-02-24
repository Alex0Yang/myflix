class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :video, :user
  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video
  delegate :title, to: :video, prefix: true
  delegate :name, to: :category, prefix: true

  def rating
    comment = Comment.where(user: user, video: video).first
    comment.rate if comment
  end

end
