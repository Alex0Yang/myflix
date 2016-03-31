require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      alice = Fabricate(:user)
      set_current_user alice
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create, leader_id: 5 }
    end

    it "redirect to people page" do
      alice = Fabricate(:user)
      set_current_user alice
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "current_user follow the leader" do
      alice = Fabricate(:user)
      set_current_user alice
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(current_user.following_relationships.first.leader).to eq(bob)
    end

    it "cannot follow someone twice" do
      alice = Fabricate(:user)
      set_current_user alice
      bob = Fabricate(:user)
      Fabricate(:relationship, follower_id: alice.id, leader_id: bob.id)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it "cannot follow himself" do
      alice = Fabricate(:user)
      set_current_user alice
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 3 }
    end

    it "redirect to the people page" do
      alice = Fabricate(:user)
      set_current_user alice
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it "delete the relationship if the current_user is the follower" do
      alice = Fabricate(:user)
      set_current_user alice
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current_user is not the follower" do
      alice = Fabricate(:user)
      set_current_user alice
      ted = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: ted, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end
end
