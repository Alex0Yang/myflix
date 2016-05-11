class VideosController < ApplicationController
  before_action :user_auth

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @comment = Comment.new
  end

  def search
    @search_result = Video.search_by_title(params[:title])
  end

  def comment
    @video = Video.find(params[:id])
    @comment = @video.comments.build(rate: params[:comment][:rate], user: current_user, content: params[:comment][:content])

    if @comment.save
      flash[:info] = "new comment added!"
      redirect_to video_path
    else
      render :show
    end
  end
end
