require 'spec_helper'

describe CopyCourseReservesForm do
  let(:user) { mock_model(User, :id => 1, :username => 'instructor') }

  before(:each) do
    @to_course = mock(Course, id: 'course_id', semester: FactoryGirl.create(:semester), :crosslist_id => 'crosslist_id')
    @from_course = mock(OpenCourse, id: 'from_course_id')

    CopyOldCourseReservesForm.any_instance.stub(:get_course).and_return(nil)
    CopyOldCourseReservesForm.any_instance.stub(:get_course).with('course_id').and_return(@to_course)

    OpenCourse.stub(:find).and_raise(ActiveRecord::RecordNotFound)
    OpenCourse.stub(:find).with('from_course_id').and_return(@from_course)
  end


  describe :validations do


    it "sends a 404 if the to_course is not found" do
      valid_params = { course_id: 'not_a_course_id' }

      lambda {
        CopyOldCourseReservesForm.new(user, valid_params)
      }.should raise_error ActionController::RoutingError
    end


  end


  describe :courses do

    it "returns empty array if there is no term" do
      valid_params = { course_id: 'course_id' }
      cocrf = CopyOldCourseReservesForm.new(user, valid_params)
      cocrf.courses.should == []
    end


    it "returns the courses for a specific term" do
      course = mock_model(OpenCourse, id: 'id')
      OpenCourse.stub(:where).and_return([course])

      valid_params = { course_id: 'course_id', term: 'term' }
      cocrf = CopyOldCourseReservesForm.new(user, valid_params)

      cocrf.courses.should == [course]
    end

  end


  describe :term do


  end



  describe :copy! do

    before(:each) do
      old_reserve = mock_model(OpenItem, item_type: 'chapter', location: 'test.pdf', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "1 - 2", journal_name: "journal" )

      @from_course.stub(:reserves).and_return( [ old_reserve ] )
    end


    it "returns the new items copied " do
      valid_params = { course_id: 'course_id', from_course_id: 'from_course_id' }

      items = CopyOldCourseReservesForm.new(user, valid_params).copy!
      items.size.should == 1
      items.first.title.should=="title"
      items.first.valid?.should be_true
      items.first.request.new_record?.should be_false
    end


  end


end
