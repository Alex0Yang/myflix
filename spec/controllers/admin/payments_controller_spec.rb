require 'spec_helper'

describe Admin::PaymentsController do
  context "GET index" do
    it "set @payment" do
      set_current_admin
      get :index
      expect(assigns(:payments)).to eq(Payment.all)
    end
  end
end
