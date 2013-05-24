require 'spec_helper'
Reserve

describe AdminUpdateMetaData do

  before(:each) do
    stub_courses!

    @reserve = BookReserve.new_request(Course.new)

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

end
