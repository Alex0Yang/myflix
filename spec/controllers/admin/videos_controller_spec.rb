require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it "set @video to be a new record" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_kind_of(Video)
      expect(assigns(:video)).to be_new_record
    end

    it "sets the flash error message for regular user" do
      set_current_user
      get :new
      should set_flash[:danger]
    end
    it "redirects the regular user to the home path" do
      set_current_user
      get :new
      should redirect_to root_path
    end
  end
end
