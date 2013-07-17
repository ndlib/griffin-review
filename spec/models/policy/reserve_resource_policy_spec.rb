require 'spec_helper'


describe ReserveResourcePolicy do


  describe :complete? do
    it "returns true if the item cannot have resources" do
      ReserveResourcePolicy.any_instance.stub(:can_have_resource?).and_return(false)

      ReserveResourcePolicy.new(double(Reserve)).complete?.should be_true
    end

    it "returns true if the item can have resources and it has a resource " do
      ReserveResourcePolicy.any_instance.stub(:can_have_resource?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:has_resource?).and_return(true)

      ReserveResourcePolicy.new(double(Reserve)).complete?.should be_true
    end

    it "returns false if the item can have resources and it does not have a resource" do
      ReserveResourcePolicy.any_instance.stub(:can_have_resource?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:has_resource?).and_return(false)

      ReserveResourcePolicy.new(double(Reserve)).complete?.should be_false
    end
  end


  describe "#can_have_file_resource?" do

    it "returns true if the type of the request is a book chapter" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_true
    end


    it "returns true if the type of the request is an article " do
      reserve = mock_reserve FactoryGirl.create(:request, :journal_file), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_true
    end


    it "returns false if the type is a book" do
      reserve = mock_reserve FactoryGirl.create(:request, :book), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_false
    end


    it "returns false if the type is a video" do
      reserve = mock_reserve FactoryGirl.create(:request, :video), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_false
    end


    it "returns false if the tyoe is an audio" do
      reserve = mock_reserve FactoryGirl.create(:request, :audio), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_file_resource?.should be_false
    end
  end


  describe :has_file_resource? do

    it "returns true if the reserve has a file and it can have files " do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub(:file).and_return("file")

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_file_resource?).and_return(true)

      policy.has_file_resource?.should be_true
    end


    it "returns false if the reserve has a file but cannot have a file attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub(:file).and_return("file")

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_file_resource?).and_return(false)

      policy.has_file_resource?.should be_false
    end


    it "returns false if the reserve does not have a file but can have a file attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub(:file).and_return(nil)
      reserve.pdf.clear

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_file_resource?).and_return(true)

      policy.has_file_resource?.should be_false
    end


    it "returns false if the reserve does not  have a file and cannot have files attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.pdf.clear

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_file_resource?).and_return(false)

      policy.has_file_resource?.should be_false
    end

  end


   describe "#can_have_url_resource?" do

    it "returns true if the type of the request is a book chapter" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_false
    end


    it "returns true if the type of the request is an article " do
      reserve = mock_reserve FactoryGirl.create(:request, :journal_url), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_true
    end


    it "returns false if the type is a book" do
      reserve = mock_reserve FactoryGirl.create(:request, :book), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_false
    end


    it "returns false if the type is a video" do
      reserve = mock_reserve FactoryGirl.create(:request, :video), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_true
    end


    it "returns false if the tyoe is an audio" do
      reserve = mock_reserve FactoryGirl.create(:request, :audio), nil
      policy = ReserveResourcePolicy.new(reserve)

      policy.can_have_url_resource?.should be_true
    end
  end


  describe :has_url_resource? do

    it "returns true if the reserve has a url and it can have urls " do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub(:url).and_return("url")

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_url_resource?).and_return(true)

      policy.has_url_resource?.should be_true
    end


    it "returns false if the reserve has a url but cannot have a url attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub(:url).and_return("url")

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_url_resource?).and_return(false)

      policy.has_url_resource?.should be_false
    end


    it "returns false if the reserve does not have a url but can have a url attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub(:url).and_return(nil)

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_url_resource?).and_return(true)

      policy.has_url_resource?.should be_false
    end


    it "returns false if the reserve does not  have a url and cannot have urls attached" do
      reserve = mock_reserve FactoryGirl.create(:request, :book_chapter), nil
      reserve.stub(:url).and_return("url")

      policy = ReserveResourcePolicy.new(reserve)
      policy.stub(:can_have_url_resource?).and_return(false)

      policy.has_url_resource?.should be_false
    end
  end

  describe :can_be_linked_to? do
    before(:each) do
      @semester = double(Semester)
      @reserve   = double(Reserve)
      @reserve.stub(:semester).and_return(@semester)

      @policy = ReserveResourcePolicy.new(@reserve)
    end

    it "returns true if the listing requires a download and it is the current semester" do
      @semester.stub(:current?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:has_file_resource?).and_return(true)

      @policy.can_be_linked_to?.should be_true
    end


    it "returns true if the listing is a url and the semester is current"  do
      @semester.stub(:current?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:has_file_resource?).and_return(false)
      ReserveResourcePolicy.any_instance.stub(:has_url_resource?).and_return(true)

      @policy.can_be_linked_to?.should be_true
    end


    it "returns false if the listing does not require a download or a url and is in the current semester " do
      @semester.stub(:current?).and_return(true)
      ReserveResourcePolicy.any_instance.stub(:has_file_resource?).and_return(false)
      ReserveResourcePolicy.any_instance.stub(:has_url_resource?).and_return(false)

      @policy.can_be_linked_to?.should be_false
    end


    it "returns false if the listing is not in the current semester and it requires a download" do
      @semester.stub(:current?).and_return(false)
      ReserveResourcePolicy.any_instance.stub(:has_file_resource?).and_return(true)

      @policy.can_be_linked_to?.should be_false
    end


    it "returns false if the reserve is not in the current semester and it is a url" do
      @semester.stub(:current?).and_return(false)
      ReserveResourcePolicy.any_instance.stub(:has_file_resource?).and_return(false)
      ReserveResourcePolicy.any_instance.stub(:has_url_resource?).and_return(true)

      @policy.can_be_linked_to?.should be_false
    end


  end
end
