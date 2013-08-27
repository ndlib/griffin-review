require 'spec_helper'


describe API::CourseSearchApi do


  before(:each) do
    API::Base.stub(:get).and_return(results)
  end


  it "returns an array of courses with the crosslist id" do
    expect(API::CourseSearchApi.courses_by_crosslist_id('id').class).to eq(Array)
    expect(API::CourseSearchApi.courses_by_crosslist_id('id').size).to eq(3)
  end




  def results
    file = File.join(Rails.root, 'spec', 'fixtures', 'json_save', 'course_search_api', 'search_example.json')
    File.read(file)
  end

end
