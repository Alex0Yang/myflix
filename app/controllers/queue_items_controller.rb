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
    current_user.normalize_position
    redirect_to my_queue_path
  end
  def update_queue
    begin
      update_queue_item
      current_user.normalize_position
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position number."
    end

    redirect_to my_queue_path
  end

  private

  def update_queue_item
    ActiveRecord::Base.transaction do
      params[:queue_item].each do |queue_item_hash|
        queue_item = QueueItem.find(queue_item_hash[:id])
        if queue_item.user == current_user
          queue_item.update_attributes!(position: queue_item_hash[:position])
        end
      end
    end
  end

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
