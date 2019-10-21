require 'spec_helper'


describe CourseUser do

  before(:each) do
    @user = double(User, username: 'username', first_name: "firstname", last_name: "lastname", display_name: "displayname", email: "email")
    @course_user = CourseUser.new(@user, @course, 'enrollment', 'banner')
    @course = double(Course)
  end

  it "has a username field" do
    expect(@course_user.username).to eq('username')
  end

  it "has a first_name" do
    expect(@course_user.first_name).to eq('firstname')
  end

  it "has a last_name" do
    expect(@course_user.last_name).to eq('lastname')
  end

  it "display_name" do
    expect(@course_user.display_name).to eq('displayname')
  end

  it "has an email field" do
    expect(@course_user.email).to eq('email')
  end


  describe "role" do

    it "allows role to be enrollment" do
      expect{ CourseUser.new(@user, @course, 'enrollment', 'banner')}.to_not raise_error
    end

    it "allows a role to be instructor" do
      expect{ CourseUser.new(@user, @course, 'instructor', 'banner')}.to_not raise_error
    end

    it "does not allow a course user to be created with out the correct value"  do
      expect{ CourseUser.new(@user, @course, 'incorrect', 'banner')}.to raise_error
    end
  end


  describe "source" do

    it "allows source to be banner" do
      expect{ CourseUser.new(@user, @course, 'enrollment', 'banner')}.to_not raise_error
    end

    it "allows a source to be exception" do
      expect{ CourseUser.new(@user, @course, 'instructor', 'exception')}.to_not raise_error
    end

    it "does not allow a course user to be created with out the correct value"  do
      expect{ CourseUser.new(@user, @course, 'enrollment', 'incorrect')}.to raise_error
    end

  end


  describe :can_be_deleted? do

    it "returns true if the users is an exception " do
      expect(CourseUser.new(@user, @course, 'enrollment', 'exception').can_be_deleted?).to be_truthy
    end

    it "returns false if the user is from banner" do
      expect(CourseUser.new(@user, @course, 'enrollment', 'banner').can_be_deleted?).to be_falsey
    end
  end


  describe :factory do

    it "creates an active record user if the user does not exhist" do
      user_return = { givenname: ['Robert'], sn: ['Bobbers'], ndvanityname: ['Bob'], mail: ['bob@bob.com'], displayname: ['Bob J Bobbers']}
      User.stub(:ldap_lookup).and_return(user_return)
      Rails.configuration.stub(:ldap_lookup_flag).and_return(true)

      user = CourseUser.netid_factory('jhartzle', @course, 'enrollment', 'banner')
      expect(user.user.new_record?).to be_falsey
      expect(user.username).to eq('jhartzle')
      expect(user.display_name).to eq('Bob J Bobbers')
    end


    it "uses the exhisting user if the the user record exhists" do
      User.stub(:username).and_return([double(User, username: 'jhartzle', display_name: "Jon Hartzler", new_record?: false )])
      user = CourseUser.netid_factory('jhartzle', @course, 'enrollment', 'banner')
      expect(user.username).to eq('jhartzle')
      expect(user.display_name).to eq('Jon Hartzler')
    end


    it "handles a nil netid" do
      user = CourseUser.netid_factory(nil, @course, 'enrollment', 'banner')

      expect(user.display_name).to eq("")
      expect(user.username).to eq("")
    end

  end


end
