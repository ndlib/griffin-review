require 'spec_helper'


describe ReserveFileResourcePolicy do


  describe "#can_have_file_resource?" do

    it "returns true if the type of the request is a book chapter" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      policy = ReserveFileResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_true
    end


    it "returns true if the type of the request is an article " do
      reserve = mock_reserve FactoryGirl.create(:request, :journal_file), nil
      policy = ReserveFileResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_true
    end


    it "returns false if the type is a book" do
      reserve = mock_reserve FactoryGirl.create(:request, :book), nil
      policy = ReserveFileResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_false
    end


    it "returns false if the type is a video" do
      reserve = mock_reserve FactoryGirl.create(:request, :video), nil
      policy = ReserveFileResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_false
    end


    it "returns false if the tyoe is an audio" do
      reserve = mock_reserve FactoryGirl.create(:request, :audio), nil
      policy = ReserveFileResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_false
    end
  end


  describe :has_file_resource? do

    it "returns true if the reserve has a file and it can have files " do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:file).and_return("file")

      policy = ReserveFileResourcePolicy.new(reserve)
      policy.stub!(:can_have_file_resource?).and_return(true)

      policy.has_file_resource?.should be_true
    end


    it "returns false if the reserve has a file but cannot have a file attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:file).and_return("file")

      policy = ReserveFileResourcePolicy.new(reserve)
      policy.stub!(:can_have_file_resource?).and_return(false)

      policy.has_file_resource?.should be_false
    end


    it "returns false if the reserve does not have a file but can have a file attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:file).and_return(nil)

      policy = ReserveFileResourcePolicy.new(reserve)
      policy.stub!(:can_have_file_resource?).and_return(true)

      policy.has_file_resource?.should be_false
    end


    it "returns false if the reserve does not  have a file and cannot have files attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub!(:file).and_return("file")

      policy = ReserveFileResourcePolicy.new(reserve)
      policy.stub!(:can_have_file_resource?).and_return(false)

      policy.has_file_resource?.should be_false
    end

  end
end
