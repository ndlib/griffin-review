require 'spec_helper'


describe ReserveCanBeLinkedToPolicy do

  before(:each) do
    @semester = mock(Semester)
    @reserve   = mock(Reserve)
    @reserve.stub!(:semester).and_return(@semester)

    @policy = ReserveCanBeLinkedToPolicy.new(@reserve)
  end

  it "returns true if the listing requires a download and it is the current semester" do
    @semester.stub!(:current?).and_return(true)
    ReserveFileResourcePolicy.any_instance.stub(:has_file_resource?).and_return(true)

    @policy.can_be_linked_to?.should be_true
  end


  it "returns true if the listing is a url and the semester is current"  do
    @semester.stub!(:current?).and_return(true)
    ReserveFileResourcePolicy.any_instance.stub(:has_file_resource?).and_return(false)
    ReserveUrlResourcePolicy.any_instance.stub(:has_url_resource?).and_return(true)

    @policy.can_be_linked_to?.should be_true
  end


  it "returns false if the listing does not require a download or a url and is in the current semester " do
    @semester.stub!(:current?).and_return(true)
    ReserveFileResourcePolicy.any_instance.stub(:has_file_resource?).and_return(false)
    ReserveUrlResourcePolicy.any_instance.stub(:has_url_resource?).and_return(false)

    @policy.can_be_linked_to?.should be_false
  end


  it "returns false if the listing is not in the current semester and it requires a download" do
    @semester.stub!(:current?).and_return(false)
    ReserveFileResourcePolicy.any_instance.stub(:has_file_resource?).and_return(true)

    @policy.can_be_linked_to?.should be_false
  end


  it "returns false if the reserve is not in the current semester and it is a url" do
    @semester.stub!(:current?).and_return(false)
    ReserveFileResourcePolicy.any_instance.stub(:has_file_resource?).and_return(false)
    ReserveUrlResourcePolicy.any_instance.stub(:has_url_resource?).and_return(true)

    @policy.can_be_linked_to?.should be_false
  end

end
