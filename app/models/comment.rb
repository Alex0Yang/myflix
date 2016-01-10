class Comment < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :rate, :review, :user_id, :video_id
end
