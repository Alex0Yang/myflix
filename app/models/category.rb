class Category < ActiveRecord::Base
  has_many :videos, -> { order("created_at DESC") }, class_name: "Video"
  validates_presence_of :name

  def recent_videos
    videos.first(6)
    #开始我用的是 videos.order("create_at DESC").first(6)
    #而在has_many中指定了另外一个排序，order("title"),
    #结果实际排序结果还是按照title,这是我实现的方法中一个隐藏的bug
    #刚开始还没发现出来，后面用kevin的测试案例才发现
  end
end
