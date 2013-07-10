require 'spec_helper'

describe CopyReserve do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:user) { mock_model(User, id: 1, username: 'username' )}
  let(:to_course) { mock(Course, id: 'course_id', semester: semester, crosslist_id: 'crosslist_id') }


  describe :copy_book_chapter do
    before(:each) do
      old_reserve = mock_model(OpenItem, item_type: 'chapter', location: 'test.pdf', title: "title", author_firstname: "fname", author_lastname: "lname" )

      @new_reserve = CopyOldReserve.new(user, to_course, old_reserve).copy
    end

    it " copies a book chapter" do
      @new_reserve.request.new_record?.should be_false
    end


    it "sets the book chapter title" do
      @new_reserve.title.should == "title"
    end


    it "sets a pdf for download" do
      @new_reserve.pdf.present?.should be_true
    end


    it "sets the type correctly " do
      @new_reserve.type.should == "BookChapterReserve"
    end


    it "sets the workflow state to new " do
      @new_reserve.workflow_state.should == "new"
    end


    it "sets the creator of the work" do
      @new_reserve.creator.should == "fname lname"
    end

    it "sets the overwrite_nd_meta_data to true" do
      @new_reserve.overwrite_nd_meta_data?.should be_true
    end


  end


end
