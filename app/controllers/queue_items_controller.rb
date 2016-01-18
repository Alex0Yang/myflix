class QueueItemsController < ApplicationController
  before_action :user_auth
  def index
    @queue_items = current_user.queue_items
  end
end
