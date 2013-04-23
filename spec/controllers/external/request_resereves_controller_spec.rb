require 'spec_helper'

describe RequestReservesController do

  describe :new do

    it "returns a successful response" do
      get :new, :prof_listing_id => 1
      response.should be_success
    end


    it "sets a course variable" do
      get :new, :prof_listing_id => 1
      assigns(:request_reserve).should be_true
    end


  end

end
