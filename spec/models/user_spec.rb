require 'spec_helper'

describe User do
    it 'have email, full_name' do
      should validate_presence_of :full_name
      should validate_presence_of  :email
    end

    it 'have secure password' do
      should have_secure_password
    end

    it 'have uniq email address' do
      should validate_uniqueness_of :email
    end
end
