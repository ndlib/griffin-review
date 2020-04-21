require 'spec_helper'

describe CopyCourseReservesForm do

  def build_controller(params)
    double(CopyReservesController, params: params)
  end

  let(:user) { User.new(:id => 1, :username => 'instructor', :admin => false) }
  let(:course_search) { CourseSearch.new }
  let(:semester) { FactoryBot.create(:semester) }
  let(:next_semester) { FactoryBot.create(:next_semester) }
  let(:from_course) { double(Course, semester: semester, :id => 'from_course_id', :title => 'from title', :primary_instructor => double(User, display_name: 'name'), :crosslist_id => 'from_reserve_id') }
  let(:to_course) { double(Course, semester: next_semester, :id => 'to_course_id', :title => 'to title', :primary_instructor => double(User, display_name: 'name'), :crosslist_id => 'to_reserve_id') }
  let(:valid_params) { { course_id: to_course.id, from_course_id: from_course.id } }
  let(:controller) { build_controller(valid_params) }

  subject { described_class.new(user, controller) }
  before(:each) do

    CourseSearch.any_instance.stub(:get).and_return(nil)
    CourseSearch.any_instance.stub(:get).with(from_course.id).and_return(from_course)
    CourseSearch.any_instance.stub(:get).with(to_course.id).and_return(to_course)

  end


  it "displays the from course title" do
    expect(subject.from_course_title).to eq "#{from_course.title} - #{from_course.semester.full_name}"
  end


  it "displays the to course title" do
    expect(subject.to_course_title).to eq "#{to_course.title} - #{to_course.semester.full_name}"
  end


  describe :copy do

    it "is returns true when it is successful" do
      reserve = Reserve.factory(FactoryBot.create(:request, :available), from_course)
      from_course.stub(:reserve).with(reserve.id).and_return(reserve)

      valid_params.merge!({reserve_ids: [ reserve.id ]})
      reserves = subject.copy_items()
      expect(reserves.first.id).to_not eq reserve.id
      expect(reserves.first.item.title).to eq reserve.item.title
    end


    it "skips reserve ids that are not real reserves" do
      valid_params.merge!({ reserve_ids: [  5234234, "a", Object.new ] })

      reserves = subject.copy_items()
      reserves.should == []
    end


    it "skips if nothing is passed in" do

      reserves = subject.copy_items()
      reserves.should == []
    end
  end

  describe '#copy_from_reserves' do
    it 'does not include removed reserves' do
      reserve1 = double(Reserve, workflow_state: 'available')
      reserve2 = double(Reserve, workflow_state: 'removed')
      from_course.stub(:reserves).and_return([reserve1, reserve2])
      expect(subject.copy_from_reserves).to eq([reserve1])
    end
  end

  describe '#instructor' do
    it 'is the user' do
      expect(subject.instructor).to eq(user)
    end

    describe 'admin' do
      let(:user) { mock_model(User, :id => 1, :username => 'instructor', :admin? => true) }

      it 'is the to_course instructor' do
        expect(subject.instructor).to eq(to_course.primary_instructor)
        expect(subject.instructor).to_not eq(user)
      end
    end
  end

  describe '#semester_instructed_courses' do
    it 'calls CourseSearch#instructed_courses with the instructor netid' do
      subject.stub(:instructor).and_return(double(User, username: 'newinstructor'))
      expect_any_instance_of(CourseSearch).to receive(:instructed_courses).with('newinstructor', semester.code).and_return(['courses'])
      expect(subject.semester_instructed_courses(semester)).to eq(['courses'])
    end
  end


  describe :step1? do

    it "returns true if the to course is set and the from course is not " do
      valid_params.delete(:from_course_id)
      subject.step1?.should be_truthy
    end


    it "returns false if the to course is set" do
      subject.step1?.should be_falsey
    end

  end


  describe :step2 do

    it "returns true if both the from course and the to course are set " do
      subject.step2?.should be_truthy
    end

    it "returns false if the the from course is not set " do
      valid_params.delete(:from_course_id)
      subject.step2?.should be_falsey
    end

  end


  describe :validations do

    it "sends a 404 if the from_course is not found" do
      valid_params.merge!({ course_id: 'not_a_course' })

      lambda {
        subject
      }.should raise_error ActionController::RoutingError
    end


    it "allows to_course to be set " do
      valid_params.delete(:from_course_id)

      lambda {
        subject
      }.should_not raise_error
    end


    it "does fails if there is no to_course " do
      valid_params.delete(:course_id)

      lambda {
        subject
      }.should raise_error ActionController::RoutingError

    end

    it "sends a 404 if the from course is not found" do
      valid_params.merge!({ from_course_id: 'not_a_course' })

      lambda {
        subject
      }.should raise_error ActionController::RoutingError
    end


    it "sends a 404 if the to course cannot have new reserves added to it" do
      CreateNewReservesPolicy.any_instance.stub(:can_create_new_reserves?).and_return(false)

      lambda {
        subject
      }.should raise_error ActionController::RoutingError
    end

  end
end
