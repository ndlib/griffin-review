require 'spec_helper'

describe UserCourseListing do

  let(:student_user) { mock(User, :username => 'student') }
  let(:instructor_user) { mock(User, :username => 'instructor') }
  let(:inst_stu_user)  { mock(User, :username => 'inst_stu') }

  let(:semester) { FactoryGirl.create(:semester)}
  let(:previous_semester) { FactoryGirl.create(:previous_semester)}

  before(:each) do
    semester
    stub_courses!
  end

  describe :course do

    it "returns a course the student belongs to" do
      reserves = UserCourseListing.new(student_user, semester.code)

      reserves.course("current_22557").title.should == "201220_CSC_33963"
      reserves.course("current_22557").instructor_name.should == "William Purcell"
    end

    it "returns nil if the user is not a part of the class" do
      reserves = UserCourseListing.new(student_user, semester.code)

      reserves.course("current_2234").should be_nil
    end


    it "returns the course even if the course is not in the current semester passed" do
      reserves = UserCourseListing.new(student_user, semester.code)
      reserves.course("current_22557").should_not be_nil

      prev_reserves = UserCourseListing.new(student_user, previous_semester.code)
      prev_reserves.course("current_22557").should_not be_nil
    end


    it "returns instructed courses from the semester passed in" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      reserves.course("current_25823").should_not be_nil
    end

  end


  describe :instructed_courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      reserves.instructed_courses_with_reserves.size.should == 1
    end

    it "returns a list of instructed couses for the semester setup in reserves"
  end


  describe :instructed_courses do

    it "returns all the instructed courses" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      reserves.instructed_courses.size.should == 2
    end

  end


  describe :courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      reserves = UserCourseListing.new(student_user, semester.code)
      reserves.courses_with_reserves.size.should == 5
    end

    it "return [] if the student has no reserves in the specified semester"

    it "only returns courses with reserves"

    it "returns results only for the current semester not a passed in semester" do
      reserves = UserCourseListing.new(student_user, semester.code)
      prev_reserves = UserCourseListing.new(student_user, previous_semester.code)

      prev_reserves.courses_with_reserves.collect{ |c| c.id}.should == reserves.courses_with_reserves.collect{ |c| c.id}
    end

  end


  describe :enrolled_courses do

    it "returns all the courses the current user is enrolled in" do
      reserves = UserCourseListing.new(student_user, semester.code)
      reserves.enrolled_courses.size.should == 11
    end


    it "returns results only for the current semester not a passed in semester" do
      reserves = UserCourseListing.new(student_user, semester.code)
      prev_reserves = UserCourseListing.new(student_user, previous_semester.code)

      prev_reserves.enrolled_courses.collect{ |c| c.id}.should == reserves.enrolled_courses.collect{ |c| c.id}
    end
  end



  describe :all_semsters do

    it "orders them cronologically" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      ps = previous_semester
      cs = semester

      reserves.all_semesters.first.should == cs
      reserves.all_semesters.last.should == ps
    end
  end


  describe :semester do

    it "selects the current semester if no semester is passed in" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      ps = previous_semester
      cs = semester

      reserve = UserCourseListing.new("current_user")
      reserve.semester.should == cs
    end


    it "finds the semester by id that was passed into the constructor" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      ps = previous_semester
      cs = semester

      reserve = UserCourseListing.new("current_user", ps.code)
      reserve.semester.should == ps
    end
  end


  describe :copy_course_listings do

    it "returns a copy course listing" do
      reserves = UserCourseListing.new(instructor_user, semester.code)
      reserves.copy_course_listing("current_22557", "current_25823").class.should == CopyReserves
    end
  end


  def stub_courses!
    API::Person.stub!(:courses) do  | netid, semester |
      path = File.join(Rails.root, "spec/fixtures/json_save/", "#{netid}_#{semester}.json")
      file = File.open(path, "rb")
      contents = file.read

      ActiveSupport::JSON.decode(contents)["people"].first
    end
  end

end
