require 'spec_helper'

describe User do
    it { should validate_presence_of :full_name }

    it { should validate_presence_of  :email }

    it { should have_many(:comments) }

    it { should have_secure_password }

    it { should validate_uniqueness_of :email }

    it { should have_many(:queue_items).order(:position) }
end
