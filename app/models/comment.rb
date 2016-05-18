class Comment < ActiveRecord::Base
  belongs_to :video, touch: true
  belongs_to :user

  validates_presence_of :rate, :content, :user_id, :video_id

  delegate :title, to: :video, prefix: true
end
