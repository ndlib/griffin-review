require 'spec_helper'


describe AddUserExeceptionForm do

  let(:user) { double(User) }

  describe :validations do

    before(:each) do
      @course = double(Course, id: 1, title: "Title" )
      CourseSearch.any_instance.stub(:get).and_return(@course)
    end

    it "requires netid" do
      expect(AddUserExeceptionForm.new(user, { course_id: 1})).to have(1).error_on(:netid)
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

    before(:each) do
      stub_courses!
    end


    it "adds an enrollment exception for a netid" do
      auef = AddUserExeceptionForm.new(user, { course_id: 'current_multisection_crosslisted', add_user_exeception_form: { role: 'enrollment', netid: 'netid' } } )
      expect(auef.save_user_exception).to be_true
      expect(UserCourseException.user_exceptions('netid', 'current').size).to eq(1)
    end


    it "adds an instructional enrollment exception for a netid " do
      auef = AddUserExeceptionForm.new(user, { course_id: 'current_multisection_crosslisted', add_user_exeception_form: { role: 'instructor', netid: 'netid' } } )
      expect(auef.save_user_exception).to be_true
      expect(UserCourseException.user_exceptions('netid', 'current').size).to eq(1)
    end


  end
end
