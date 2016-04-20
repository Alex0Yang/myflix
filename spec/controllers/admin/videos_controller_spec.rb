require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    context "admin" do
      it "render new page" do
        alice = Fabricate(:user, admin: true)
        set_current_user alice
        get :new
        should render_template('new')
      end

      it "set @video" do
        alice = Fabricate(:user, admin: true)
        set_current_user alice
        get :new
        expect(assigns(:video)).to be_kind_of(Video)
      end
    end

    context "non admin" do
      it "show the notice" do
        alice = Fabricate(:user)
        set_current_user alice
        get :new
        should set_flash[:danger]
      end
      it "redirect to root page" do
        alice = Fabricate(:user)
        set_current_user alice
        get :new
        should redirect_to root_path
      end
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end
end
