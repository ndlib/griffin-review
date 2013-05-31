require 'spec_helper'

describe ReserveSearch do

  let(:course_api) { CourseApi.new }

  before(:each) do
    stub_courses!
    @course = course_api.get('student', "current_normalclass_100")

    valid_params = { title: "aTitle", course: @course, requestor_netid: "bob", workflow_state: "new", type: 'BookReserve'}
    @new_reserve = Reserve.new(valid_params)
    @new_reserve.save!

    valid_params = { title: "bTitle", course: @course, requestor_netid: "bob", workflow_state: "inprogress", type: 'BookReserve'}
    @inprogress_reserve = Reserve.new(valid_params)
    @inprogress_reserve.save!


    valid_params = { title: "cTitle", course: @course, requestor_netid: "bob", workflow_state: "available", type: 'BookReserve'}
    @available_reserve = Reserve.new(valid_params)
    @available_reserve.save!
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


    it "raises and error if the reserve is not found" do
      lambda {
        reserve_search = ReserveSearch.new
        reserve_search.get(2342342, @course)
      }.should raise_error
    end
  end

end
