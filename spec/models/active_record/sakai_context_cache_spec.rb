require 'spec_helper'

describe SakaiContextCache do

  it "basic valid sakai_context_cache passes validation" do
    valid_params = {:context_id => 'context id', :course_id => 'course id' }
    SakaiContextCache.new(valid_params).should be_valid
  end


  it "requires a context id" do
    SakaiContextCache.new.should have(1).error_on(:context_id)
  end


  it "requires a course id" do
    SakaiContextCache.new.should have(1).error_on(:course_id)
  end

end
