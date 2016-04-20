class AdminsController < ApplicationController
  before_action :require_admin

  def require_admin
    if current_user && !current_user.admin?
      flash[:danger] = "Only admin can visit this page."
      redirect_to root_path
    else
      user_auth
    end
  end
end
