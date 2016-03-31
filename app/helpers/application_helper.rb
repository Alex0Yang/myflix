module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map { |n| [pluralize(n, "Star"), n]}, selected)
  end

  def show_follow_button?
    ! ((current_user.following_relationships.map(&:leader_id).include?(@user.id)) || (current_user == @user) )
  end
end
