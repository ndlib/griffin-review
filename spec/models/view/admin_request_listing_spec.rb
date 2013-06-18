require 'spec_helper'

describe UserArchiveCourseListing do

  let (:user) { mock(User, :username => 'admin')}

  it "gets incomplete listings when the filter is new " do
    ReserveSearch.any_instance.should_receive(:new_and_inprocess_reserves_for_semester)

    arl = AdminRequestListing.new(user, {filter: 'new' })
    arl.reserves
  end

  it "gets incomplete listings when the filter is unset" do
    ReserveSearch.any_instance.should_receive(:new_and_inprocess_reserves_for_semester)

    arl = AdminRequestListing.new(user, { })
    arl.reserves
  end


  it "gets incomplete listings when the filter is inprocess" do
    ReserveSearch.any_instance.should_receive(:new_and_inprocess_reserves_for_semester)

    arl = AdminRequestListing.new(user, {filter: 'inprocess' })
    arl.reserves
  end


  it "gets complete only listings when the filter is complete" do
    ReserveSearch.any_instance.should_receive(:available_reserves_for_semester)

    arl = AdminRequestListing.new(user, {filter: 'complete' })
    arl.reserves
  end


  it "gets all listings when the filter is all" do
    ReserveSearch.any_instance.should_receive(:all_reserves_for_semester)

    arl = AdminRequestListing.new(user, {filter: 'all' })
    arl.reserves
  end


  it "defaults to the current semester if none is passed in" do
    s = FactoryGirl.create(:semester)

    arl = AdminRequestListing.new(user, {filter: 'all' })
    arl.semester.id.should == s.id
  end



  it "switches the semester to the one passed in" do
    FactoryGirl.create(:semester)
    s = FactoryGirl.create(:previous_semester)

    arl = AdminRequestListing.new(user, { semester_id: s.id})
    arl.semester.id.should == s.id
  end


  it "has a filter" do
    arl = AdminRequestListing.new(user, {  })
    arl.respond_to?(:filter)
    arl.filter.class.should == AdminRequestFilter
  end

end
