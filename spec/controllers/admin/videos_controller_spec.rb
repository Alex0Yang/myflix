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

    it_behaves_like "require_admin" do
      let(:action) { post :new }
    end

  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "require_admin" do
      let(:action) { post :create }
    end

    context "valid input" do
      let(:category) { Fabricate(:category) }
      before do
        set_current_admin
        post :create, video: { title: "new video", category_id: category.id, description: "good show!" }
      end

      it "create new video" do
        expect(category.videos.count).to eq(1)
      end

      it "redirect to new_video_add_page" do
        should redirect_to new_admin_video_path
      end

      it "show successful message" do
        should set_flash[:success]
      end
    end

    context "invalid input" do
      let(:category) { Fabricate(:category) }
      before do
        set_current_admin
        post :create, video: { category_id: category.id, description: "good show!" }
      end

      it "does not create new video" do
        expect(category.videos.count).to eq(0)
      end

      it "render new page" do
        should render_template('new')
      end

      it "show error message" do
        should set_flash[:danger]
      end

      it "set @video" do
        expect(assigns(:video)).to be_kind_of Video
      end
    end
  end
end
