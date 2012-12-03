require 'spec_helper'

describe Role do

  before(:all) do
    @role1 = Factory.build(:admin_role)
    @role2 = Factory.build(:faculty_role)
  end

  it do
    @role1.should be_valid
  end

  it "should have both a name and a description" do
    @role1.name.should_not be_blank
    @role1.description.should_not be_blank
  end

  it "should not validate if name or description are blank" do
    @bad_role = Factory.build(:admin_role, :name => '')
    @bad_role.should have_at_least(1).error_on(:name)
  end

end
