class VideosController < ApplicationController
  before_action :user_auth

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @search_result = Video.search_by_title(params[:title])
  end
end
