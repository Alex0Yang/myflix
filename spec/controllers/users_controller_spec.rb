require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "set the @user" do
      get :new
      expect(assigns(:user)).to be_kind_of(User)
    end
  end

  describe "POST create" do
    context "user's input is valid" do
      let!(:user) { Fabricate.attributes_for(:user) }
      before { post :create, user: user }

      it "user registers successfully" do
        expect(User.find_by(email: user[:email]).full_name).to eq(user[:full_name])
      end

      it "redirect to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "user's input in invalid" do
      before do
        post :create, user: { full_name: "some" }
      end

      it "cannot registers" do
        expect(User.find_by full_name: "some").to be nil
      end

      it "render new template" do
        expect(response).to render_template :new
      end

      it "set @user" do
        expect(assigns(:user)).to be_kind_of(User)
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 3 }
    end

    it "set the @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end
