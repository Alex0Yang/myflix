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

  def advanced_search
    if params[:query]
      search_options = {
        comments: (params[:comments] if params[:comments].present?),
        rating_from: ( params[:rating_from] if params[:rating_from].present? && (params[:rating_from] != "-") ),
        rating_to: ( params[:rating_to] if params[:rating_to].present? && (params[:rating_to] != "-") )
      }
      @videos = Video.search(params[:query], search_options).records.to_a
    else
      @videos = []
    end
  end
end
