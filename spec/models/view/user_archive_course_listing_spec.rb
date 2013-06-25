require 'spec_helper'

describe UserArchiveCourseListing do

  let(:instructor_user) { mock(User, :username => 'instructor') }


  describe :archived_semesters do

    it "returns all the semesters that are in the past." do
      FactoryGirl.create(:semester)
      previous_semester = FactoryGirl.create(:previous_semester)

      UserArchiveCourseListing.new(instructor_user).archived_semesters.should == [previous_semester]
    end
  end


  describe :has_any_archived_instructed_courses? do
    it "returns true if there is a single archived course that have reserves" do
      previous_semester = FactoryGirl.create(:previous_semester)

      UserArchiveCourseListing.any_instance.stub(:archived_semesters).and_return([ previous_semester])
      course = mock_course_with_reserve

      CourseSearch.any_instance.stub(:instructed_courses).and_return([course])

      UserArchiveCourseListing.new(instructor_user).has_any_archived_instructed_courses?.should be_true
    end


    it "returns false if there are no archived courses that have reserves" do
      previous_semester = FactoryGirl.create(:previous_semester)
      UserArchiveCourseListing.any_instance.stub(:archived_semesters).and_return([previous_semester])
      course = mock_course_without_reserve

      CourseSearch.any_instance.stub(:instructed_courses).and_return([course])

      UserArchiveCourseListing.new(instructor_user).has_any_archived_instructed_courses?.should be_false
    end
  end



  describe :semester_has_courses? do

    it "returns true if the semester has courses" do
      semester = FactoryGirl.create(:semester)
      course = mock_course_with_reserve

      CourseSearch.any_instance.stub(:instructed_courses).and_return([course])

      UserArchiveCourseListing.new(instructor_user).semester_has_courses?(semester).should be_true
    end


    it "returns false if the semester does not have courses" do
      semester = FactoryGirl.create(:semester)
      course = mock_course_without_reserve

      CourseSearch.any_instance.stub(:instructed_courses).and_return([course])

      UserArchiveCourseListing.new(instructor_user).semester_has_courses?(semester).should be_false
    end
  end


  describe :semester_instructed_courses_with_reserves do

    it "returns only courses that have reserves" do
      semester = FactoryGirl.create(:semester)
      course1 = mock_course_with_reserve
      course2 = mock_course_without_reserve

      CourseSearch.any_instance.stub(:instructed_courses).and_return([course1, course2])

      UserArchiveCourseListing.new(instructor_user).semester_instructed_courses_with_reserves(semester).should == [course1]
    end


    it " returns only courses for the semester passed in" do
      # tested in course_search_spec
    end
  end


  def mock_course_with_reserve
    course1 = mock(Course, id: 'course_id', crosslist_id: 'crosslist_id', title: 'course 1')
    reserve = mock_reserve FactoryGirl.create(:request, :available), course1
    course1.stub(:reserves).and_return([reserve])

    course1
  end


  def mock_course_without_reserve
    mock(Course, id: 'course_id', crosslist_id: 'crosslist_id', title: 'course 1', reserves: [])
  end
end
