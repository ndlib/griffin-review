require 'spec_helper'

describe CourseSearch do

  let(:course_search) { CourseSearch.new }
  let(:semester) { FactoryGirl.create(:semester)}


  describe "api_access" do
    it "only calls the api once for enrolled and instucted courses per netid and semster"
  end


  describe "#enrolled_courses" do
    before(:each) do
      VCR.use_cassette "course_search/edavis12-201310" do
        @current_courses = CourseSearch.new.enrolled_courses('edavis12', '201310')
      end

      VCR.use_cassette "course_search/bcarrico-201300" do
        @previous_courses = CourseSearch.new.enrolled_courses('bcarrico', '201300')
      end
    end

    it "returns each of the users courses for the current semester" do
      expect(@current_courses.size).to eq(6)
    end


    it "returns the courses from a different semester" do
      expect(@previous_courses.size).to eq(2)
    end


    it "it does not aggregatge the crosslists only the one the student is a part of " do
      # see the instructors listing for the same course below.
      res = ["201310_ACCT_20100"]
      expect(@current_courses[0].sections.collect(&:triple).uniq).to eq(res)
    end


    it "aggregates the sections" do
      res = ["201310_11294", "201310_11299", "201310_15479", "201310_11300"]
      expect(@current_courses[0].sections.collect(&:id).uniq).to eq(res)
    end

    it "handles empty response"

    it "handles a 500 response from the api"

  end


  describe "#instructed_courses" do

    before(:each) do

      VCR.use_cassette "course_search/jotousa1-201310" do
        @current_courses = CourseSearch.new.instructed_courses('jotousa1', '201310')
      end

      VCR.use_cassette "course_search/jotousa1-201300" do
        @previous_courses = CourseSearch.new.instructed_courses('jotousa1', '201300')
      end
    end


    it "returns each of the users courses for the current semester" do
      expect(@current_courses.size).to eq(2)
    end


    it "returns the courses from a different semester" do
      expect(@previous_courses.size).to eq(1)
    end


    it "aggregates each of the crosslisted courses into one." do
      res = ["201310_ACCT_20100", "201310_BAAL_20100", "201310_BAEG_20100", "201310_BASC_20100"]
      expect(@current_courses[0].sections.collect(&:triple).uniq).to eq(res)
    end


    it "collects courses that are not cross listed into one course with one section" do
      res = ["201310_BAUG_30760"]
      expect(@current_courses[1].sections.collect(&:triple).uniq).to eq(res)
    end


    it "handles empty response"

    it "handles a 500 response from the api"
  end



  describe :get do

    context :found_search do
      before(:each) do
        VCR.use_cassette "course_search/201310_JE_JH_JJ_JK" do
          @course =  course_search.get('201310_JE_JH_JJ_JK')
        end
      end

      it "returns the course specified" do
        expect(@course.id).to eq("201310_JE_JH_JJ_JK")
      end

      it "combines sections from crosslistings into one result " do
        res = ["201310_ACCT_20100", "201310_BAAL_20100", "201310_BAEG_20100", "201310_BASC_20100"]
        expect(@course.sections.collect(&:triple).uniq).to eq(res)
      end
    end

    context :missing_course_404 do
      before(:each) do
        VCR.use_cassette "course_search/missing" do
          @course =  course_search.get('not_a_course_id')
        end
      end

      it "returns the missing course object" do
        expect(@course.class).to be(CourseMock)
      end

    end

    it "handles a 500 response from the api"


  end


  describe :search do

    before(:each) do
      VCR.use_cassette "course_search/search-augustine" do
        @search_result = course_search.search('201310', 'augustine')
      end
    end

    it "returns an array of courses searched for " do
      expect(@search_result.size).to eq(1)
    end

    it "returns course objects" do
      expect(@search_result.first.class).to eq(Course)
    end

    it "handles empty response"

    it "handles a 500 response from the api"

  end



  describe "course exceptions" do
    before(:each) do
      VCR.use_cassette "course_search/201310_JE_JH_JJ_JK" do
        @course =  course_search.get('201310_JE_JH_JJ_JK')
      end
    end

    it "merges student exceptions into the student couse list" do
      UserCourseException.create_enrollment_exception!(@course.id, '201310', 'student')

      CourseSearch.any_instance.stub(:person_course_search).and_return({'enrolled_courses' => [], 'instructed_courses' => []})
      courses = course_search.enrolled_courses('student', '201310')

      courses.last.id.should == @course.id
    end


    it "mergers instructor exceptions into the instructor course list" do
      UserCourseException.create_instructor_exception!(@course.id, '201310', 'instructor')

      CourseSearch.any_instance.stub(:person_course_search).and_return({'enrolled_courses' => [], 'instructed_courses' => []})
      courses = course_search.instructed_courses('instructor', '201310')
      courses.last.id.should == @course.id
    end


    it "creates a course object for the passed in course" do
      UserCourseException.create_instructor_exception!(@course.id, '201310',  'instructor')

      CourseSearch.any_instance.stub(:person_course_search).and_return({'enrolled_courses' => [], 'instructed_courses' => []})
      courses = course_search.instructed_courses('instructor', '201310')

      courses.last.class.should == Course
    end
  end


  def test_result_has_course_ids(courses, valid_ids)
    courses.size.should == valid_ids.size

    courses.each do | course |
      valid_ids.include?(course.id).should be_truthy
    end
  end


  def display_course_ids(courses)
    puts courses.collect { | c | c.id }.inspect
  end
end
