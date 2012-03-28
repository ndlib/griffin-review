require 'spec_helper'

describe Group do
  describe "#create_new_group" do
    let(:group) { Factory(:group) }

    it "checks to make sure group was created" do
      group.group_name.should eq(Group.find(group.group_name).group_name)
      group.destroy 
    end

    it "should place groups into categories"
    it "should alphabetize the group names"

  end
end
