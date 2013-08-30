require 'spec_helper'

describe FindUserSectionInCourse do

  before(:each) do
    @user = double(User, id: '1', username: 'student_user', admin?: false)
    @other_user = double(User, id: '4', username: 'other_user', admin?: false)

    @section1 = double(CourseSection, id: '1', enrollment_netids: [ ] )
    @section2 = double(CourseSection, id: '2', enrollment_netids: [ @user.username ] )

    @course = double(Course, id: '1',  sections: [ @section1, @section2 ] )

    UserRoleInCoursePolicy.any_instance.stub(:user_instructs_course?).and_return(false)
    UserIsAdminPolicy.any_instance.stub(:is_admin?).and_return(false)
  end


  it "finds the section the student is enrolled in" do
    expect(FindUserSectionInCourse.new(@course, @user).find).to eq(@section2)
  end


  it "returns nil if the user is not involved with the course at all " do
    expect(FindUserSectionInCourse.new(@course, @other_user).find).to be_nil
  end


  it "finds the first section if the user is an instructor" do
    UserRoleInCoursePolicy.any_instance.stub(:user_instructs_course?).and_return(true)
    expect(FindUserSectionInCourse.new(@course, @user).find).to eq(@section1)
  end


  it "finds the first section if the user is an administrator" do
    UserIsAdminPolicy.any_instance.stub(:is_admin?).and_return(true)
    expect(FindUserSectionInCourse.new(@course, @user).find.id).to eq(@section1.id)
  end
end
