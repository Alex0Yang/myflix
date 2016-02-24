class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :video, :user
  validates_numericality_of :position, only_integer: true

  delegate :category, to: :video
  delegate :title, to: :video, prefix: true
  delegate :name, to: :category, prefix: true

  def rating
    comment.rate if comment
  end

  def rating=(rating)
    if comment
      comment.update_attribute(:rate, rating)
    else
      new_comment = Comment.new(user: user, video: video, rate: rating)
      new_comment.save(validate: false)
    end
  end

  private

  def comment
    @comment ||= Comment.where(user: user, video: video).first
  end

end
