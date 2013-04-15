require 'spec_helper'

describe StudentListingsController do

  describe :index do

    it "returns a successful response" do
      get :index
      response.should be_success
    end


    it "passes student_reserves to the view" do
      get :index

      assigns(:student_reserves).should_not be_nil
      assigns(:student_reserves).class.should == StudentReserves
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

  end
end
