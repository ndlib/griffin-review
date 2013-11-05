require 'spec_helper'


describe AddUserExeceptionForm do

  let(:user) { double(User) }

    before(:each) do
      @course = double(Course, id: 1, term: '201310')
      AddUserExeceptionForm.any_instance.stub(:get_course).and_return(@course)
    end

  describe :validations do


    it "requires netid" do
      expect(AddUserExeceptionForm.new(user, { course_id: 1})).to have(1).error_on(:netid)
    end


    it "validates that the netid is in LDAP" do
      User.any_instance.stub(:save!).and_raise(User::LDAPException.new("LDAP Lookup failed for 'username'"))
      auef = AddUserExeceptionForm.new(user, { course_id: 'current_multisection_crosslisted', add_user_exeception_form: { role: 'enrollment', netid: 'netid' } } )
      expect(auef.save_user_exception).to be_false
      expect(auef.errors.size).to eq(1)
    end


    it "requires a role" do
      expect(AddUserExeceptionForm.new(user, { course_id: 1})).to have(2).error_on(:role)
    end

    it "requires roles to be one of the valid options" do
      ['enrollment', 'instructor'].each do | role |
        expect(AddUserExeceptionForm.new(user, { course_id: 1, add_user_exeception_form: { role: role } } )).to have(0).error_on(:role)
      end
    end


    it "errors when an invalid role is passed in " do
      ["role", 23234, "blabla"].each  do | role |
        expect(AddUserExeceptionForm.new(user, { course_id: 1, add_user_exeception_form: { role: role } } )).to have(1).error_on(:role)
      end
    end
  end


  describe :persistance do

    it "adds an enrollment exception for a netid" do

      auef = AddUserExeceptionForm.new(user, { course_id: 'current_multisection_crosslisted', add_user_exeception_form: { role: 'enrollment', netid: 'netid' } } )
      auef.stub(:test_user?).and_return(true)

      expect(auef.save_user_exception).to be_true
      expect(UserCourseException.user_exceptions('netid', @course.term).size).to eq(1)
    end


    it "adds an instructional enrollment exception for a netid " do
      auef = AddUserExeceptionForm.new(user, { course_id: 'current_multisection_crosslisted', add_user_exeception_form: { role: 'instructor', netid: 'netid' } } )
      auef.stub(:test_user?).and_return(true)

      expect(auef.save_user_exception).to be_true
      expect(UserCourseException.user_exceptions('netid', @course.term).size).to eq(1)
    end


  end
end
