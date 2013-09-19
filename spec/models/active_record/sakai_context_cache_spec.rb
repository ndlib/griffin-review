require 'spec_helper'

describe SakaiContextCache do

  it "basic valid sakai_context_cache passes validation" do
    valid_params = {:context_id => 'context id', :external_id => 'external id', :course_id => 'course id', :user_id => 'user id', :term => 'term'}
    SakaiContextCache.new(valid_params).should be_valid
  end


  it "requires a context id" do
    SakaiContextCache.new.should have(1).error_on(:context_id)
  end


  it "requires a external id" do
    SakaiContextCache.new.should have(1).error_on(:external_id)
  end


  it "requires a course id" do
    SakaiContextCache.new.should have(1).error_on(:course_id)
  end


  it "requires a user id" do
    SakaiContextCache.new.should have(1).error_on(:user_id)
  end


  it "requires a term" do
    SakaiContextCache.new.should have(1).error_on(:term)
  end

end
