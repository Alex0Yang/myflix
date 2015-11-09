require "spec_helper"

describe Category do
  it "can have many videos" do
    should have_many(:videos)
  end
end
