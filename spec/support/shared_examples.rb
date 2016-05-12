shared_examples "redirects to the my queue page" do
  it "redirects" do
    action
    expect(response).to redirect_to my_queue_path
  end
end

shared_examples "require_sign_in" do
  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "require_admin" do
  it "sets the flash error message for regular user" do
    set_current_user
    action
    should set_flash[:danger]
  end

  it "redirects the regular user to the home path" do
    set_current_user
    action
    should redirect_to root_path
  end
end
