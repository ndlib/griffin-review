require 'spec_helper'

describe SakaiIntegrator do
  subject { described_class.new('context', 'username') }

  let(:term) { '201420' }
  let(:course_number) { 'HIST 12345' }

  let(:course) { double(Course, crosslisted_course_ids: [ course_number ] )}

  before(:each) do
    allow_any_instance_of(CourseSearch).to receive(:all_courses).and_return([course])
  end

  context "course is found" do
    let(:sakai_context) { double(SakaiContextId, term: term, course_number: course_number) }

    before(:each) do
      allow(subject).to receive(:sakai_context).and_return(sakai_context)
    end

    it "returns the corse" do
      expect(subject.get).to eq(course)
    end

    it "users course search" do
      expect_any_instance_of(CourseSearch).to receive(:all_courses).with('username', term).and_return([course])
      subject.get
    end

    it "uses the sakai_context" do
      expect(subject).to receive(:sakai_context).and_return(sakai_context)
      subject.get
    end
  end

  context "course is not found" do
    let(:sakai_context) { double(SakaiContextId, term: term, course_number: 'not found course number') }

    before(:each) do
      allow(subject).to receive(:sakai_context).and_return(sakai_context)
    end

    it "returns false" do
      expect(subject.get).to be(false)
    end
  end

  describe "#call" do

    it "calls the get method " do
      expect_any_instance_of(described_class).to receive(:get)
      described_class.call('context', 'username')
    end
  end
end
