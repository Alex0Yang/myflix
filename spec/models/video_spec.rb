require "spec_helper"

describe Video do

  it "belongs to category" do
    should belong_to(:category)
  end

  it "have a title" do
    should validate_presence_of(:title)
  end

  it "have description" do
    should validate_presence_of(:description)
  end

end
