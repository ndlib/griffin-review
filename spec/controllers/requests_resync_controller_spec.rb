require 'spec_helper'

describe RequestsResyncController do


  before(:each) do
    ReserveSearch.any_instance.stub(:get).and_return(double(Reserve, id: 1, nd_meta_data_id: 'id'))
  end


  describe :admin do
    before(:each) do
      u = FactoryBot.create(:admin_user)
      sign_in u

      RequestsResyncController.any_instance.stub(:check_admin_permission!).and_return(true)
      ReserveSynchronizeMetaData.any_instance.stub(:synchronize!).and_return(true)
    end


    it "redirects back to the request on success" do
      ResyncReserveButton.any_instance.should_receive(:resync!).and_return(true)

      put :update, id: 1
      expect(response).to redirect_to(edit_meta_data_path('1'))
    end


    it "redirects back to the request on error" do
      ResyncReserveButton.any_instance.should_receive(:resync!).and_return(false)

      put :update, id: 1
      expect(response).to redirect_to(edit_meta_data_path('1'))
    end
  end


  describe :not_admin do
    before(:each) do
      u = FactoryBot.create(:instructor)
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
