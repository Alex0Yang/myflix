require 'spec_helper'

describe Relationship do
  it { validate_uniqueness_of(:leader_id).scoped_to(:follower_id) }
end
