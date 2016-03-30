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
