require 'spec_helper'


describe UserCanViewAllCoursesPolicy do

  describe "#can_view_all_courses?" do
    it "returns true if the user circ" do
      user = double(User, :username => 'circ' )
      described_class.new(user).can_view_all_courses?.should be_true
    end

    it "returns false if the user is not circ" do
      user = double(User, :username => 'netid' )
      described_class.new(user).can_view_all_courses?.should be_false
    end
  end

end
