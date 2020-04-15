require 'spec_helper'

describe RequestsTypeController do


  before(:each) do
    ReserveSearch.any_instance.stub(:get).and_return(double(Reserve, id: 1, physical_reserve: false, electronic_reserve: true, 'attributes=' => true, 'save!' => true))
  end


  describe :admin do
    before(:each) do
      u = FactoryBot.create(:admin_user)
      sign_in u

      RequestsTypeController.any_instance.stub(:check_admin_permission!).and_return(true)
    end


    it "redirects back to the request on success" do
      PhysicalElectronicReserveForm.any_instance.should_receive(:update_reserve_type!).and_return(true)

      put :update, id: 1
      expect(response).to redirect_to(request_path('1'))
    end


    it "redirects back to the request on error" do
      PhysicalElectronicReserveForm.any_instance.should_receive(:update_reserve_type!).and_return(false)

      put :update, id: 1
      expect(response).to redirect_to(edit_type_path('1'))
    end
  end


  describe :not_admin do
    before(:each) do
      u = FactoryBot.create(:instructor)
      sign_in u

      RequestsTypeController.any_instance.stub(:check_admin_permission!).and_raise(ActionController::RoutingError.new("error"))
    end

    it "404s" do
      expect {
        put :update, id: 1
      }.to raise_error(ActionController::RoutingError)
    end
  end
end
