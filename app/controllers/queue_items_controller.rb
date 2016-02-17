class QueueItemsController < ApplicationController
  before_action :user_auth
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find params[:video_id]
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    QueueItem.where(user: current_user, id: params[:id]).first.try(:destroy)
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user_id: current_user.id, position: new_queue_video_position) unless current_user_queued_video?(video)
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def new_queue_video_position
    current_user.queue_items.count + 1
  end
end
