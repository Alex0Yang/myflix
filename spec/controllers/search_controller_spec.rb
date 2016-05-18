require 'spec_helper'

describe SearchController do
  context "GET index" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  context "POST search" do
    it "set @video according search terms" do
    end
  end
end
