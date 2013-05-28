require 'spec_helper'

Reserve

describe AdminUpdateMetaData do

  before(:each) do
    stub_courses!

    @course = CourseApi.new.get('instructor', 'current_ACCT_20200')
    @reserve = Course.reserve_test_data(@course)[6]

    @update_meta_data = AdminUpdateMetaData.new(@reserve)
  end

  describe :validations do

    it "requires a nd_meta_data_id if overwrite_nd_meta_data is false" do
      @reserve.overwrite_nd_meta_data = false

      @update_meta_data.should have(1).error_on(:nd_meta_data_id)
    end


    it "does not require nd_meta_data_id if we have set the item to overwrite nd meta data" do
      @reserve.overwrite_nd_meta_data = true

      @update_meta_data.should have(0).error_on(:nd_meta_data_id)
    end


    it "does not require title if overwrite_nd_meta_data is false" do
      @reserve.overwrite_nd_meta_data = false

      @update_meta_data.should have(0).error_on(:title)
    end


    it "requires title if overwrite_nd_meta_data is true" do
      @reserve.overwrite_nd_meta_data = true

      @update_meta_data.should have(1).error_on(:title)
    end


    it "does not require creator if overwrite_nd_meta_data is false" do
      @reserve.overwrite_nd_meta_data = false

      @update_meta_data.should have(0).error_on(:creator)
    end


    it "requires creator if overwrite_nd_meta_data is true" do
      @reserve.overwrite_nd_meta_data = true

      @update_meta_data.should have(1).error_on(:creator)
    end



    it "does not require journal_title if overwrite_nd_meta_data is false" do
      @reserve.overwrite_nd_meta_data = false

      @update_meta_data.should have(0).error_on(:journal_title)
    end


    it "requires journal_title if overwrite_nd_meta_data is true" do
      @reserve.overwrite_nd_meta_data = true

      @update_meta_data.should have(1).error_on(:journal_title)
    end
  end


  describe "workflow_state" do

    it "updates checks ensure_state_is_inprogress! when the object is loaded." do
      AdminUpdateMetaData.any_instance.should_receive(:ensure_state_is_inprogress!)
      AdminUpdateMetaData.new(@reserve)
    end


    it "updates the reserve to be in progress if it is new" do
      reserve = Course.reserve_test_data(@course)[6]
      reserve.id = 11

      reserve.workflow_state.should == "new"

      AdminUpdateMetaData.new(reserve)
      reserve.workflow_state.should == "inprocess"
    end


    it "does not update the workflow_state if it is available " do
      reserve = Course.reserve_test_data(@course)[1]
      reserve.workflow_state.should == "available"

      AdminUpdateMetaData.new(reserve)
      reserve.workflow_state.should == "available"
    end

  end

end
