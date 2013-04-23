require 'spec_helper'

describe CopyReservesController do

  describe :create do

    it "returns a successful response" do
      post :create, :prof_listing_id => 1
      response.should be_success
    end


    it "sets a copy_requests variable" do
      post :create, :prof_listing_id => 1
      assigns(:copy_course_listing).should be_true
    end


    it "redirects to the original page if there is an error."
  end

end
