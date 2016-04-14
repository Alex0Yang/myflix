require 'spec_helper'

describe User do
    it { should validate_presence_of :full_name }

    it { should validate_presence_of  :email }

    it { should have_many(:comments).order('created_at desc') }

    it { should have_secure_password }

    it { should validate_uniqueness_of :email }

    it { should have_many(:queue_items).order(:position) }

    describe "#queued_video?" do
      it "returns true when the user queued the video" do
        alice = Fabricate(:user)
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: alice, video: video)
        expect(alice.queue_video?(video)).to be true
      end
      it "returns false when the user hasn't queued the video" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        queue_item = Fabricate(:queue_item, user: alice, video: video)
        expect(bob.queue_video?(video)).to be false
      end
    end

    describe "#reviews_count" do
      it "return the count of reviews" do
        alice = Fabricate(:user)
        Fabricate(:comment, user:alice)
        expect(alice.comments_count).to eq(1)
      end
    end

    describe "#queue_items_count" do
      it "return the count of queue items" do
        alice = Fabricate(:user)
        Fabricate(:queue_item, user:alice)
        expect(alice.queue_items_count).to eq(1)
      end
    end

    describe "#can_follow?" do
      it "return true if user does not have a following relationship with another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        expect(bob.can_follow?(alice)).to be_truthy
      end

      it "return false if user has a following relationship with another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        Fabricate(:relationship, follower: bob, leader: alice)
        expect(bob.can_follow?(alice)).to be_falsey
      end

      it "return false if user want to follow themselves" do
        bob = Fabricate(:user)
        expect(bob.can_follow?(bob)).to be_falsey
      end
    end
    describe "follow(another_user)" do
      it "follows another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        alice.follow(bob)
        expect(alice.follows?(bob)).to be_truthy
      end

      it "does not follow one self" do
        alice = Fabricate(:user)
        alice.follow(alice)
        expect(alice.follows?(alice)).to be false
      end

    end

    describe "follows?(another_user)"do
      it "return true if followed another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        Fabricate(:relationship, leader: alice, follower: bob)
        expect(bob.follows?(alice)).to be_truthy
      end

      it "return false if didn't followed another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        Fabricate(:relationship, leader: Fabricate(:user), follower: bob)
        expect(bob.follows?(alice)).to be false
      end
    end
end
