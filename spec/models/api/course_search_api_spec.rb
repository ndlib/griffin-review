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

  context :cache_key_date_code do

    it "sets key as the current date if it is after 5am " do
      API::CourseSearchApi.stub(:current_time).and_return("11/7/2013 05:47:AM".to_time)
      expect(API::CourseSearchApi.cache_key_date_code).to eq("11-07-2013")
    end


    it "sets the key as the previous date if the time is before 5am" do
      API::CourseSearchApi.stub(:current_time).and_return("11/7/2013 04:47:AM".to_time)
      expect(API::CourseSearchApi.cache_key_date_code).to eq("11-06-2013")
    end

  end

end
