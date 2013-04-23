require 'spec_helper'

describe ProfListingsController do

  describe :index do

    it "returns a successful response" do
      get :index
      response.should be_success
    end


    it "passes reserves to the view" do
      get :index

      assigns(:reserves).should_not be_nil
      assigns(:reserves).class.should == ReservesApp
    end
  end


  describe :show do

    it "returns a successful response" do
      get :show, id: "1"
      response.should be_success
    end


    it "passes course to the view" do
      get :show, id: "1"

      assigns(:course).should_not be_nil
      assigns(:course).class.should == Course
    end


    it "returns 404 if the course is not found" do
      get :show, id: "2"

      response.should be_not_found
    end


    it "returns a 404 if the course is not attached to the current user"

  end
end
