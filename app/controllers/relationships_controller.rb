class RelationshipsController < ApplicationController
  before_action :user_auth

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    if leader && current_user.can_follow?(leader)
      @relationship = current_user.following_relationships.build(leader: leader)
      @relationship.save
    end
    redirect_to people_path
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy if @relationship.follower == current_user
    redirect_to people_path
  end
end
