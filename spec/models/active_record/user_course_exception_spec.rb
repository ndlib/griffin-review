require 'spec_helper'

describe Item do

  describe "validations" do

    it "requires the netid" do
      UserCourseException.new.should have(1).error_on(:netid)
    end

    it "requires role" do
      UserCourseException.new.should have(2).error_on(:role)
    end

    it "requires the role is either a student or instructor " do
      [
        'adfasf',
        '32423423',
        234234234,
        Object.new
      ].each do | r |
        UserCourseException.new(role: r).should have(1).error_on(:netid)
      end
    end

  end
end
