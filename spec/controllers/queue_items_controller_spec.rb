require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "set @queue_items for the authed user" do
      user = Fabricate(:user)
      set_current_user(user)
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "redirects to the my queue page" do
      set_current_user(user)
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      set_current_user(user)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      set_current_user(user)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item that is associated with the sign in user" do
      set_current_user(user)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)
    end

    it "puts the video as the last one in the queue" do
      set_current_user(user)
      Fabricate(:queue_item, user: user)
      post :create, video_id: video.id
      video_queue_item = QueueItem.where(user: user, video: video).first
      expect(video_queue_item.position).to eq(2)
    end

    it "does not add the video the queue if the video is already in the queue" do
      set_current_user(user)
      Fabricate(:queue_item, user: user, video: video)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, video_id: video.id }
    end
  end

  describe "DELETE destroy" do
    it "redirect to my queue page" do
      user = Fabricate(:user)
      set_current_user(user)
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      user = Fabricate(:user)
      set_current_user(user)
      queue_item = Fabricate(:queue_item, user: user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "does not delete the queue item if the queue item is not in the current user's queue" do
      user_1 = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user_1)
      set_current_user
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: Fabricate(:queue_item).id }
    end

    it 'normalizes the remaining queue items' do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item1.id
      expect(queue_item2.reload.position).to eq(1)
    end
  end

  describe "POST queue_item" do
    context "with valid inputs" do
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 4) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 5) }
      before do
        set_current_user
      end

      it_behaves_like "redirects to the my queue page" do
        let(:action) { post :update_queue, queue_item: [{id: queue_item1.id, position: 3}] }
      end

      it "reorders the queue item" do
        post :update_queue, queue_item: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(current_user.queue_item_ids).to eq([queue_item2.id, queue_item1.id])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_item: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(2)
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "with invalid inputs" do
      let(:alice) { Fabricate(:user) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 4) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 5) }
      before do
        set_current_user(alice)
      end

      it_behaves_like "redirects to the my queue page" do
        let(:action) { post :update_queue, queue_item: [{id: queue_item1.id, position: 3}] }
      end

      it "sets the flash error message" do
        post :update_queue, queue_item: [{id: queue_item1.id, position: 3.5 }, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).not_to be_blank
      end

      it 'does not change the queue items' do
        post :update_queue, queue_item: [{id: queue_item1.id, position: 3 }, {id: queue_item2.id, position: 2.5}]
        expect(queue_item1.reload.position).to eq(4)
        expect(queue_item2.reload.position).to eq(5)
      end
    end

    context "with unauthenticated users" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :update_queue, queue_item: [{id: 1, position: 3 }, {id: 2, position: 2.5}] }
      end
    end

    context "with queue_items that do not belong to the current user" do
      it 'does not change the queue items' do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 4)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 5)
        post :update_queue, queue_item: [{id: queue_item1.id, position: 3 }, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(4)
      end
    end
  end
end
