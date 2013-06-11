require 'spec_helper'


describe ReserveUrlResourcePolicy do


  describe "#can_have_url_resource?" do

    it "returns true if the type of the request is a book chapter" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      policy = ReserveUrlResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_false
    end


    it "returns true if the type of the request is an article " do
      reserve = mock_reserve FactoryGirl.create(:request, :journal_url), nil
      policy = ReserveUrlResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_true
    end


    it "returns false if the type is a book" do
      reserve = mock_reserve FactoryGirl.create(:request, :book), nil
      policy = ReserveUrlResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_false
    end


    it "returns false if the type is a video" do
      reserve = mock_reserve FactoryGirl.create(:request, :video), nil
      policy = ReserveUrlResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_true
    end


    it "returns false if the tyoe is an audio" do
      reserve = mock_reserve FactoryGirl.create(:request, :audio), nil
      policy = ReserveUrlResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_true
    end
  end


  describe :has_url_resource? do

    it "returns true if the reserve has a url and it can have urls " do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:url).and_return("url")

      policy = ReserveUrlResourcePolicy.new(reserve)
      policy.stub!(:can_have_url_resource?).and_return(true)

      policy.has_url_resource?.should be_true
    end


    it "returns false if the reserve has a url but cannot have a url attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:url).and_return("url")

      policy = ReserveUrlResourcePolicy.new(reserve)
      policy.stub!(:can_have_url_resource?).and_return(false)

      policy.has_url_resource?.should be_false
    end


    it "returns false if the reserve does not have a url but can have a url attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:url).and_return(nil)

      policy = ReserveUrlResourcePolicy.new(reserve)
      policy.stub!(:can_have_url_resource?).and_return(true)

      policy.has_url_resource?.should be_false
    end


    it "returns false if the reserve does not  have a url and cannot have urls attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:url).and_return("url")

      policy = ReserveUrlResourcePolicy.new(reserve)
      policy.stub!(:can_have_url_resource?).and_return(false)

      policy.has_url_resource?.should be_false
    end

  end
end
