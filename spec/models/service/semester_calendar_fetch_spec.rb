require 'spec_helper'

describe SemesterCalendarFetch do
  
  let(:full_calendar) { Hash.from_xml(File.open(Rails.root.join('spec', 'fixtures', 'academic_calendar.xml')).read).to_ostruct }
  subject { SemesterCalendarFetch.new }
  
  describe "#fetch_calendar" do

    before(:each) do
      expect(subject.send(:rest_connection)).to receive(:transact).and_return(full_calendar)
    end

    it "marshals calendar data from source into openstruct" do
      expect(subject.send(:fetch_calendar)).to be_a_kind_of(OpenStruct)
    end

    it "should provide access to calendar properties" do
      expect(subject.send(:fetch_calendar)).to respond_to(:bedework)
    end

  end
  
  describe "#parse_calendar" do

    before(:each) do
      expect(subject).to receive(:fetch_calendar).and_return(full_calendar)
      subject.send(:parse_calendar)
    end

    it "parse out the correct number of calendar events" do
      expect(subject.send(:calendar_events)).to have(15).items 
    end

    it "sets the first and last day of the calendar" do
      expect(subject.send(:calendar_first_day).to_s).to eq '08/22/2014'
      expect(subject.send(:calendar_last_day).to_s).to eq '06/04/2015' 
    end

  end

  describe "#next_semester" do
    
    before(:each) do
      expect(subject).to receive(:fetch_calendar).and_return(full_calendar)
      subject.send(:parse_calendar)
    end

    context "when next semester found in calendar" do

      it "instantiates one future semester" do
        expect(subject.next_semester).to be_a_kind_of(SemesterDateNormalizer)
      end

      it "should have the correct begin date" do
        expect(subject.next_semester.begin_date.to_s).to eq '08/26/2014'
      end

      it "should have the correct end date" do
        expect(subject.next_semester.end_date.to_s).to eq '12/11/2014'
      end

    end

    context "when the first and last day of classes is not in calendar" do

      it "returns a not found string" do
        expect(subject).to receive(:semester_dates_found?).and_return(false)
        expect(subject.next_semester).to eq :not_found
      end
    end
  end


end
