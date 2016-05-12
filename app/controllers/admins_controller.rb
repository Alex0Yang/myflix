class AdminsController < ApplicationController
  before_action :user_auth
  before_action :require_admin

  def require_admin
    unless current_user.admin?
      flash[:danger] = "Only admin can visit this page."
      redirect_to root_path
    end
  end
end
