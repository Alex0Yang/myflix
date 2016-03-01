require 'spec_helper'

describe User do
    it { should validate_presence_of :full_name }

    it { should validate_presence_of  :email }

    it { should have_many(:comments) }

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
end
