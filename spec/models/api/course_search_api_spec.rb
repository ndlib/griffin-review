require 'spec_helper'


describe API::CourseSearchApi do


  before(:each) do

    VCR.use_cassette 'course_search_api/crosslist_id' do
      @result = API::CourseSearchApi.courses_by_crosslist_id('201310_JE_JH_JJ_JK')
    end
  end


  it "returns an array of courses with the crosslist id" do
    expect(@result.class).to eq(Array)
    expect(@result.size).to eq(4)
  end

end
