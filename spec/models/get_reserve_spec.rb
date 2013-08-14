require 'spec_helper'

describe GetReserve do

  before(:each) do
    @user = FactoryGirl.create(:student)

    semester = FactoryGirl.create(:semester)

    @course = double(Course, :id => 'from_course_id', :title => 'from title', :instructor_name => 'name', :crosslist_id => 'crosslist_id', :reserve_id => 'from_reserve_id')
    GetReserve.any_instance.stub(:get_course).with(@course.id).and_return(@course)

    @reserve =  mock_reserve FactoryGirl.create(:request, :book_chapter), @course
    @course.stub(:reserve).with(@reserve.id).and_return(@reserve)

    @valid_params = { course_id: @course.id, id: @reserve.id }
  end


  describe :approval_required? do

    it "returns true if there is no approval for the current listing and it needs one" do
      GetReserve.any_instance.stub(:reserve_requires_approval?).and_return(true)

      gcl = GetReserve.new(@user, @valid_params)
      gcl.approval_required?.should be_true
    end

    it "returns false if the item needs not approval" do
      GetReserve.any_instance.stub(:reserve_requires_approval?).and_return(false)

      gcl = GetReserve.new(@user, @valid_params)
      gcl.approval_required?.should be_false
    end

    it "returns false if the item terms needs approval and it has been approved" do
      GetReserve.any_instance.stub(:reserve_requires_approval?).and_return(true)
      @reserve.stub(:term_of_service_approved?).and_return(true)

      gcl = GetReserve.new(@user, @valid_params)
      gcl.approval_required?.should be_true
    end
  end


  describe :download_listing? do
    it "returns true if the listing should download a file" do
      @reserve.stub(:file).and_return("FILE")

      gcl = GetReserve.new(@user, @valid_params)
      gcl.download_listing?.should be_true
    end

    it "returns false if the listing should not download a file"  do
      GetReserve.any_instance.stub(:validate_input!).and_return(true)
      @reserve.pdf.clear

      gcl = GetReserve.new(@user, @valid_params)
      gcl.download_listing?.should be_false
    end
  end


  describe :download_file_path do

    it "returns the path the to file for download" do
      gcl = GetReserve.new(@user, @valid_params)
      gcl.download_file_path.include?(@reserve.pdf.path).should be_true
    end

  end


  describe :redirect_to_listing? do
    it "returns true if the listing should redirect to an external resource" do
      @reserve.stub(:url).and_return("URL")

      gcl = GetReserve.new(@user, @valid_params)
      gcl.redirect_to_listing?.should be_true
    end

    it "returns false if the listing should not redirect" do
      @reserve.stub(:url).and_return(nil)

      gcl = GetReserve.new(@user, @valid_params)
      gcl.redirect_to_listing?.should be_false
    end
  end


  describe :redirect_uri do

    it "returns the uri to redirect to" do
      @reserve.stub(:url).and_return("URL")

      gcl = GetReserve.new(@user, @valid_params)
      gcl.redirect_uri.should == "URL"
    end
  end


  describe :approve_terms_of_service! do

    it "approves the terms of service for the current user" do
      gcl = GetReserve.new(@user, @valid_params)
      gcl.approve_terms_of_service!
      gcl.term_of_service_approved?.should be_true
    end


    it "defaults to false if there is no approval" do
      gcl = GetReserve.new(@user, @valid_params)
      gcl.term_of_service_approved?.should be_false
    end

  end


  describe :link_to_listing? do

    before(:each) do
      @get_reserve = GetReserve.new(@user, @valid_params)
    end


    it "returns true if the listing can be linked to" do
      ReserveResourcePolicy.any_instance.stub(:can_be_linked_to?).and_return(true)
      @get_reserve.link_to_listing?.should be_true
    end


    it "returns false if cannot be linked to" do
      ReserveResourcePolicy.any_instance.stub(:can_be_linked_to?).and_return(false)
      @get_reserve.link_to_listing?.should be_false
    end

  end


  describe :statistics do

    it "sets a statistic datapoint for the reserve " do
      ReserveStat.should_receive(:add_statistic!)
      @get_reserve = GetReserve.new(@user, @valid_params)
    end

  end

end
