require 'spec_helper'


describe ReserveIsMissingCoursePolicy do
  let(:reserve) { double(Reserve, id: 1, course: double(Course, id: 1 )) }

  describe :call do

    it "returns true if the class is the course mock" do
      reserve.course.stub(:is_a?).and_return(true)
      expect(ReserveIsMissingCoursePolicy.call(reserve)).to be_truthy
    end

    it "returns false if it is a course" do
      expect(ReserveIsMissingCoursePolicy.call(reserve)).to be_falsey
    end
  end

end
