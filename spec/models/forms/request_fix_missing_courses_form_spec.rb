require 'spec_helper'


describe RequestFixMissingCourseForm do
  semester = FactoryBot.create(:semester)
  let(:course) { double(Course, id: 'missing_course_id', semester: double(Semester, id: 1)) }
  let(:reserve) { double(Reserve, id: 1, course_id: 'missing_course_id', course: course) }
  let(:params) { {} }

  subject { described_class.new(reserve, params) }

  [:new_course_id].each do | attribute |
    it "has the form attribute, #{attribute}" do
      expect(subject).to respond_to(attribute)
      expect(subject).to respond_to("#{attribute}=")
    end
  end

  it "can display the old course_id" do
    expect(subject.old_course_id).to eq("missing_course_id")
  end


  describe :persistance do
    let(:reserve) {
      r = FactoryBot.create(:request, course_id: 'missing_course_id')
      r = Reserve.factory(r, course)

    }
    let(:params) { { new_course_id: new_course.id, fix_all_courses_with_old_course_id: false} }
    let(:new_course) { double(Course, id: "new_course_id", semester: double(Semester, id: 1))}

    before(:each) do
      CourseSearch.any_instance.stub(:get).with(new_course.id).and_return(new_course)
    end


    it "can update all the reserves with the old course_id to have the new one" do
      FactoryBot.create(:semester, id: 1 )
      res2 = FactoryBot.create(:request, course_id: 'missing_course_id')
      reserve
      params[:fix_all_courses_with_old_course_id] = true
      expect(subject.update_course_id!).to be_truthy
    end


    it "does nothing if the form is not valid" do
      subject.stub(:valid?).and_return(false)
      expect(subject.update_course_id!).to be_falsey
    end

  end

end
