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
end
