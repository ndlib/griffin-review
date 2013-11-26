require 'spec_helper'

describe RequestsOnOrderController do


  before(:each) do
    ReserveSearch.any_instance.stub(:get).and_return(double(Reserve, id: 1))
  end


  describe :admin do
    before(:each) do
      u = FactoryGirl.create(:admin_user)
      sign_in u

      RequestsOnOrderController.any_instance.stub(:check_admin_permission!).and_return(true)
      PlaceItemOnOrderForm.any_instance.stub(:currently_on_order?).and_return(true)
    end


    it "redirects back to the request on success" do
      PlaceItemOnOrderForm.any_instance.should_receive(:toggle_on_order!).and_return(true)

      put :update, id: 1
      expect(response).to redirect_to(request_path('1'))
    end


    it "redirects back to the request on error" do
      PlaceItemOnOrderForm.any_instance.should_receive(:toggle_on_order!).and_return(false)

      put :update, id: 1
      expect(response).to redirect_to(request_path('1'))
    end
  end


  describe :not_admin do
    before(:each) do
      u = FactoryGirl.create(:instructor)
      sign_in u

      RequestsOnOrderController.any_instance.stub(:check_admin_permission!).and_raise(ActionController::RoutingError.new("error"))
    end

    it "404s" do
      expect {
        put :update, id: 1
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
