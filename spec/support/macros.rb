def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def current_user
  User.find(session[:user_id])
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def sign_in(a_user=nil)
  user = a_user||= Fabricate(:user)
  visit sign_in_path
  fill_in "email", :with => user.email
  fill_in "password", :with => user.password
  click_button "Sign in"
end

def sign_in_admin(a_admin = nil)
  admin = a_admin ||= Fabricate(:admin)
  visit sign_in_path
  fill_in "email", :with => admin.email
  fill_in "password", :with => admin.password
  click_button "Sign in"
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end
