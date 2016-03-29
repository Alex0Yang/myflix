class Comment < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates_presence_of :rate, :content, :user_id, :video_id
end
