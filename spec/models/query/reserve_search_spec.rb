require 'spec_helper'

describe ReserveSearch do

  let(:semester) { FactoryGirl.create(:semester)}
  let(:previous_semester) { FactoryGirl.create(:previous_semester)}

  let(:course_api) { CourseApi.new }

  before(:each) do
    stub_courses!
    @course = course_api.get("current_multisection_crosslisted")
  end

  describe :student_and_instructor_requests do

    before(:each) do
      @new_reserve       = mock_reserve FactoryGirl.create(:request, :new, :book, :course_id => @course.reserve_id), @course
      @inprogress_reserve = mock_reserve FactoryGirl.create(:request, :inprocess, :book, :course_id => @course.reserve_id), @course
      @available_reserve = mock_reserve FactoryGirl.create(:request, :available, :book, :course_id => @course.reserve_id), @course
    end


    describe :instructor_reserves_for_course do

      it "returns all the reserves for a course" do
        reserve_search = ReserveSearch.new
        reserve_search.instructor_reserves_for_course(@course).size.should == 3
      end


      it "returns the reserves in alphabetical order" do
        reserve_search = ReserveSearch.new
        reserve_search.instructor_reserves_for_course(@course).collect{|r| r.id}.should == [@new_reserve.id, @inprogress_reserve.id, @available_reserve.id]
      end

    end


    describe :student_reserves_for_course do

      it "returns only the reserves that are visible to students" do
        reserve_search = ReserveSearch.new
        reserve_search.student_reserves_for_course(@course).size.should == 1
      end

    end

    describe :get do

      it "gets the reserve with the id " do
        reserve_search = ReserveSearch.new
        reserve_search.get(@inprogress_reserve.id, @course).id.should == @inprogress_reserve.id
      end


      it "returns nil if the record is not found" do
        reserve_search = ReserveSearch.new
        reserve_search.get(2342342, @course).should be_nil

      end
    end

  end


  describe :admin_reserve_requests do
    before(:each) do
      @new_semester1 = mock_reserve FactoryGirl.create(:request, :new, :semester_id => semester.id), @course
      @new_semester2 = mock_reserve FactoryGirl.create(:request, :new, :semester_id => previous_semester.id), @course

      @inprocess_semester1 = mock_reserve FactoryGirl.create(:request, :inprocess, :semester_id => semester.id), @course
      @inprocess_semester2 = mock_reserve FactoryGirl.create(:request, :inprocess, :semester_id => previous_semester.id), @course

      @available_semester1 = mock_reserve FactoryGirl.create(:request, :available, :semester_id => semester.id), @course
      @available_semester2 = mock_reserve FactoryGirl.create(:request, :available, :semester_id => previous_semester.id), @course
    end


    describe :new_and_inprocess_reserves_for_semester do

      it "gets all the reserves that are new and inprocess for the passed in semester" do
        reserve_search = ReserveSearch.new

        res = reserve_search.new_and_inprocess_reserves_for_semester(semester)
        res.size.should == 2
        res.collect { | r | r.id }.should == [ @new_semester1.id, @inprocess_semester1.id ]
      end
    end


    describe :available_reserves_for_semester do
      it "gets all the reserves that are available " do
        reserve_search = ReserveSearch.new

        res = reserve_search.available_reserves_for_semester(semester)
        res.size.should == 1
        res.collect { | r | r.id }.should == [ @available_semester1.id ]
      end
    end


    describe :all_reserves_for_semester do

      it "gets all the reserves for a semester" do
        reserve_search = ReserveSearch.new

        res = reserve_search.all_reserves_for_semester(semester)
        res.size.should == 3
        res.collect { | r | r.id }.should == [  @new_semester1.id, @inprocess_semester1.id, @available_semester1.id ]
      end
    end
  end



end
