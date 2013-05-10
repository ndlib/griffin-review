require 'spec_helper'

describe ReservesApp do

  let(:current_user) { mock(User, :username => 'jdan') }
  let(:reserves) { ReservesApp.new(current_user, semester.id)}
  let(:semester) { FactoryGirl.create(:semester)}

  describe :course do

    it "returns a course the student belongs to" do
      VCR.use_cassette 'courses/jdan' do

        reserves.course("19745").title.should == "201210_ACMS_60882"
        reserves.course("19745").instructor_name.should == "Jiahan Li"
      end
    end

    it "returns nil if the student is not a part of the class"


    it "returns nil if the course is not in the current semester passed into student reserves" do
      VCR.use_cassette 'courses/jdan' do
        reserves.course("19746").should be_nil
      end
    end

    it "returns only enrolled courses in the current semester even if the the semester is set to the next "


    it "returns instructed courses from the semester passed in"

  end


  describe :instructed_courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      VCR.use_cassette 'courses/jdan' do
        reserves.instructed_courses_with_reserves.size.should == 1
      end
    end

    it "returns a list of instructed couses for the semester setup in reserves"
  end


  describe :instructed_courses_without_reserves do

    it "returns a list of courses that have do not have reserves for the current user" do
      VCR.use_cassette 'courses/jdan' do
        reserves.instructed_courses_without_reserves.size.should == 1
      end
    end
  end


  describe :instructed_courses do

    it "returns all the instructed courses" do
      VCR.use_cassette 'courses/jdan' do
        reserves.instructed_courses.size.should == 2
      end
    end

  end


  describe :courses_with_reserves do

    it "returns a list of courses that have reserves for the current user" do
      VCR.use_cassette 'courses/jdan' do
        reserves.courses_with_reserves.size.should == 2
      end
    end

    it "return [] if the student has no reserves in the specified semester"

    it "only returns courses with reserves"

    it "returns results only for the current semester" do
      VCR.use_cassette 'courses/jdan' do
        reserves.courses_without_reserves.size.should == 1
      end
    end


    it "only returns results for the current semester"

  end


  describe :courses_without_reserves do

    it "returns a list of courses that have do not have reserves for the current user" do
      VCR.use_cassette 'courses/jdan' do
        reserves.courses_without_reserves.size.should == 1
      end
    end

    it "return [] if the student has no classes with out reserves in the specified semester"

    it "only returns courses without reserves"


    it "returns results only for the current semester" do
      VCR.use_cassette 'courses/jdan' do
        reserves.courses_without_reserves.size.should == 1
      end
    end

    it "only returns results for the current semester"

  end

  describe :enrolled_courses do

    it "returns all the courses the current user is enrolled in"

    it "returns only the current semester "
  end


  describe :all_semsters do

    it "orders them cronologically" do
      ps = FactoryGirl.create(:previous_semester)
      cs = FactoryGirl.create(:semester)

      reserves.all_semesters.first.should == cs
      reserves.all_semesters.last.should == ps
    end

  end


  describe :semester do

    it "selects the current semester if no semester is passed in" do
      ps = FactoryGirl.create(:previous_semester)
      cs = FactoryGirl.create(:semester)

      reserve = ReservesApp.new("current_user")
      reserve.semester.should == cs
    end


    it "finds the semester by id that was passed into the constructor" do
      ps = FactoryGirl.create(:previous_semester)
      cs = FactoryGirl.create(:semester)

      reserve = ReservesApp.new("current_user", ps.id)
      reserve.semester.should == ps
    end
  end


  describe :copy_course_listings do

    it "returns a copy course listing" do
      VCR.use_cassette 'courses/jdan' do
        reserves.copy_course_listing(1, 2).class.should == CopyReserves
      end
    end

  end

end
