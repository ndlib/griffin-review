require 'spec_helper'

describe ListUsersCourses do

  let(:student_user) { double(User, :username => 'student') }
  let(:instructor_user) { double(User, :username => 'instructor') }
  let(:inst_stu_user)  { double(User, :username => 'inst_stu') }

  let(:semester) { FactoryBot.create(:semester)}
  let(:previous_semester) { FactoryBot.create(:previous_semester)}

  before(:each) do
    @course = double(Course, id: 'id', semester: FactoryBot.create(:semester))
    @upcoming_course = double(Course, id: 'next_id', semester: FactoryBot.create(:next_semester))
  end


  describe :build_from_params do
    before(:each) do
      @controller = double(ApplicationController, current_user: student_user)
    end


    it "builds the object form the controller" do
      expect(ListUsersCourses.build_from_params(@controller).class).to eq(ListUsersCourses)
    end
  end


  describe :instructed_courses do

    before(:each) do
      CourseSearch.any_instance.stub(:instructed_courses).and_return([ @course ] )
      CourseSearch.any_instance.stub(:instructed_courses).with(instructor_user.username, @upcoming_course.semester.code).and_return([ @upcoming_course ])
    end


    it "returns a list of both the current upcoming instructed courses" do
      reserves = ListUsersCourses.new(instructor_user)
      reserves.instructed_courses.size.should == 2
    end



    describe :current_instructed_courses do
      it "returns all the instructed courses" do
        reserves = ListUsersCourses.new(instructor_user)
        reserves.current_instructed_courses.size.should == 1
        reserves.current_instructed_courses.first.id.should == "id"
      end
    end


    describe :upcoming_instructed_courses do
      it "returns all the instructed courses for the next semester" do
        reserves = ListUsersCourses.new(instructor_user)
        reserves.upcoming_instructed_courses.size.should == 1
        reserves.upcoming_instructed_courses.first.id.should == "next_id"
      end


      it "returns an empty array if there is no next semester" do
        reserves = ListUsersCourses.new(instructor_user)
        reserves.stub(:has_next_semester?).and_return(false)

        reserves.upcoming_instructed_courses.should == []
      end

    end

  end

  describe :enrolled_courses do

    before(:each) do
      @course.stub(:published_reserves).and_return( [ double(Reserve, id: '1') ])
      @no_reserve_course = double(Course, id: 'id2', semester: @course.semester, published_reserves: [] )

      CourseSearch.any_instance.stub(:enrolled_courses).and_return([ @course, @no_reserve_course ] )
      CourseSearch.any_instance.stub(:enrolled_courses).with(student_user.username, @upcoming_course.semester.code).and_return([ @upcoming_course ])
    end

    it "returns a list of courses that have reserves for the current user" do
      reserves = ListUsersCourses.new(student_user)
      reserves.enrolled_courses.size.should == 1
    end


    it "return [] if the student has no reserves in the specified semester" do
      @course.stub(:published_reserves).and_return( [ ])

      reserves = ListUsersCourses.new(student_user)
      reserves.enrolled_courses.should == []
    end


    it "only returns courses with reserves" do
      reserves = ListUsersCourses.new(student_user)
      expect(reserves.enrolled_courses.include?(@no_reserve_course)).to be_falsey
    end

  end



  describe :all_semsters do


    it "orders them cronologically" do
      reserves = ListUsersCourses.new(instructor_user)
      second_semester = @upcoming_course.semester
      first_semester = @course.semester

      reserves.all_semesters.first.id.should == second_semester.id
      reserves.all_semesters.last.id.should == first_semester.id
    end
  end


  describe :current_semester do

    it "selects the current semester" do
      reserves = ListUsersCourses.new(instructor_user)
      next_semester = @upcoming_course.semester
      current_semester = @course.semester

      reserves.current_semester.id.should == current_semester.id
    end
  end


  describe :next_semester do

    it "gets the next semester after the current semester" do
      next_semester = @upcoming_course.semester

      reserves = ListUsersCourses.new(instructor_user)
      reserves.next_semester.should == next_semester
    end
  end
end
