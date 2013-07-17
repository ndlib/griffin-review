require 'spec_helper'

describe "Instructor New Reserve" do


  before(:each) do
    FactoryGirl.create(:semester)

    stub_ssi!
    stub_courses!
    stub_discovery!



    @test_course = CourseSearch.new.get('current_multisection_crosslisted')
    @file_reserve = mock_reserve FactoryGirl.create(:request, :available, :book_chapter), @test_course
    Course.any_instance.stub(:reserves).and_return([@file_reserve])

    u = FactoryGirl.create(:instructor, username: @test_course.primary_instructor["netid"])
    login_as u
  end


  it "allows items to be removed through the ui" do

    visit course_reserves_path(@test_course.id)

#    click_link("delete_reserve_#{@file_reserve.id}")

  end


end
