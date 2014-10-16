require 'spec_helper'

describe SemesterBuild do
  
  let(:full_calendar) { Hash.from_xml(File.open(Rails.root.join('spec', 'fixtures', 'academic_calendar.xml')).read).to_ostruct }
  let(:full_calendar_sans_semester) { Hash.from_xml(File.open(Rails.root.join('spec', 'fixtures', 'academic_calendar_2.xml')).read).to_ostruct }
  subject { SemesterBuild.new }

  describe "#find_next_semester" do

    before(:each) do
      s = Semester.new(code: '11111', full_name: 'Fall Semester', date_begin: Date.today, date_end: Date.today + 15)
      s.save!
    end

    context "when the next semester is found in the calendar" do
      it "should create a new active record semester" do
        SemesterCalendarFetch.any_instance.stub(:fetch_calendar).and_return(full_calendar)
        subject.find_next_semester
        expect(Semester.count).to eq 2
        expect(Semester.last.code).to eq '201410'
        expect(Semester.last.full_name).to eq 'Fall 2014'
        expect(Semester.last.date_begin.to_s).to eq '08/26/2014'
      end
    end

    context "when the next semester is not found in the calendar" do
      it "should not create a new active record semester" do
        SemesterCalendarFetch.any_instance.stub(:fetch_calendar).and_return(full_calendar_sans_semester)
        expect(subject).to receive(:past_drop_dead_date?).and_return(false).at_least(:once)
        subject.find_next_semester
        expect(Semester.count).to eq 1
        expect(Semester.last.code).to eq '11111'
      end
    end

  end

end
  
