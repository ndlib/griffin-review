require 'spec_helper'

describe InstructorReserveRequest do

  let(:reserve) { Reserve.new() }
  let(:current_user) { "USER" }

  before(:each) do
    @instructor_reserve = InstructorReserveRequest.new(reserve, current_user)
  end


  it "has the current user associated with it" do
    @instructor_reserve.current_user.should == current_user
  end


  it " decorates a reserve object " do
    @instructor_reserve.__getobj__.should == reserve
  end

end
