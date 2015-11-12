require 'spec_helper'

describe User do
    it 'should have email, email' do
      should validate_presence_of :full_name
      should validate_presence_of  :email
    end

    it 'have secure password' do
      should have_secure_password
    end
end
