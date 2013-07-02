require 'spec_helper'

describe AdminUpdateMetaData do

  before(:each) do
    stub_courses!

    @user = mock(User, :username => 'admin')
    @course = CourseSearch.new.get('current_multisection_crosslisted')

    @reserve = mock_reserve(FactoryGirl.create(:request), @course)

    @params = { id: @reserve.id}
    @update_meta_data = AdminUpdateMetaData.new(@user, @params)
  end

  describe :validations do

    it "requires a nd_meta_data_id if overwrite_nd_meta_data is false" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(false)

      @update_meta_data.should have(1).error_on(:nd_meta_data_id)
    end


    it "does not require nd_meta_data_id if we have set the item to overwrite nd meta data" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(true)

      @update_meta_data.should have(0).error_on(:nd_meta_data_id)
    end


    it "does not require title if overwrite_nd_meta_data is false" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(false)
      @update_meta_data.should have(0).error_on(:title)
    end


    it "requires title if overwrite_nd_meta_data is true" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(true)

      @update_meta_data.should have(1).error_on(:title)
    end


    it "does not require creator if overwrite_nd_meta_data is false" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(false)

      @update_meta_data.should have(0).error_on(:creator)
    end


    it "requires creator if overwrite_nd_meta_data is true" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(true)

      @update_meta_data.should have(1).error_on(:creator)
    end



    it "does not require journal_title if overwrite_nd_meta_data is false" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(false)

      @update_meta_data.should have(0).error_on(:journal_title)
    end


    it "requires journal_title if overwrite_nd_meta_data is true" do
      Reserve.any_instance.stub(:overwrite_nd_meta_data?).and_return(true)

      @update_meta_data.should have(1).error_on(:journal_title)
    end
  end


  describe "workflow_state" do

    it "updates checks ensure_state_is_inprogress! when the object is loaded." do
      Reserve.any_instance.should_receive(:ensure_state_is_inprogress!)
      AdminUpdateMetaData.new(@user, { id: @reserve.id})
    end


    it "updates the reserve to be in progress if it is new" do
      reserve = mock_reserve(FactoryGirl.create(:request, :new), @course)
      reserve.workflow_state.should == "new"
      params = { id: reserve.id }

      AdminUpdateMetaData.new(@user, params)

      reserve.request.reload()
      reserve.workflow_state.should == "inprocess"
    end


    it "does not update the workflow_state if it is available " do
      reserve = mock_reserve(FactoryGirl.create(:request, :available), @course)
      reserve.workflow_state.should == "available"

      params = { id: reserve.id }
      AdminUpdateMetaData.new(@user, params)

      reserve.workflow_state.should == "available"
    end

  end


  describe "presistance" do

    it "returns true if the update is valid" do
      @update_meta_data.stub!(:valid?).and_return(true)

      @update_meta_data.save_meta_data.should be_true
    end

    it "returns false if the udates is invalid" do
      @update_meta_data.stub!(:valid?).and_return(false)

      @update_meta_data.save_meta_data.should be_false

    end

    it "calls save! on the reserve " do
      @update_meta_data.stub!(:valid?).and_return(true)

      Reserve.any_instance.should_receive(:save!)
      @update_meta_data.save_meta_data
    end


  end
end
