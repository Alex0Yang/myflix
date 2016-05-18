class SearchController < ApplicationController
  before_action :user_auth

  def index
  end

  def search
    search_term = params[:query]
    @videos = Video.search(search_term).records.to_a
  end
end
