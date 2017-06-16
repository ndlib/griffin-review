require 'spec_helper'

describe CoursesInReserves do
  let(:courses_in_reserves) { CoursesInReserves.new("netid") }
  let(:user_course_listing) do
    double( enrolled_courses: [], instructed_courses: [])
  end
  let(:course) { double(id: "id", title: "title", reserves: [], ) }

  before(:each) do
    allow(courses_in_reserves).to receive(:user_course_listing).and_return(user_course_listing)
  end

  it "returns the net id in the hash" do
    hash = courses_in_reserves.to_hash
    expect(hash[:netid]).to eq("netid")
  end

  describe "enrollments" do
    before(:each) do
      allow(user_course_listing).to receive(:enrolled_courses).and_return([course])
    end

    it "returns the course id in the enrollments" do
      hash = courses_in_reserves.to_hash
      expect(hash[:enrollments][0][:course_id]).to eq("id")
    end

    it "returns the course title in the enrollments" do
      hash = courses_in_reserves.to_hash
      expect(hash[:enrollments][0][:title]).to eq("title")
    end

    it "returns the link to the course" do
      hash = courses_in_reserves.to_hash
      expect(hash[:enrollments][0][:course_link]).to eq("http://reserves.library.nd.edu/courses/id/reserves")
    end
  end
end
