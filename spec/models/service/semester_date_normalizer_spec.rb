require 'spec_helper'

describe SemesterDateNormalizer do

  subject { SemesterDateNormalizer.new(begin_date: '20140115', end_date: '20140520') }

  describe "::initialize" do

    context "with required parameters" do

      it "is valid" do
        expect(subject).to be_valid
      end

      it "has a begin_date_string" do
        expect(subject.begin_date_string).to eq "20140115"
      end

      it "has an end_date_string" do
        expect(subject.end_date_string).to eq "20140520"
      end

    end

    context "without required parameters" do
      let(:no_begin_date) { SemesterDateNormalizer.new(end_date: '20141220') }
      let(:empty_begin_date) { SemesterDateNormalizer.new(begin_date: '', end_date: '20141220') }

      it "will raise error on instatiation" do
        expect{no_begin_date}.to raise_error
      end

      it "will be invalid" do
        expect(empty_begin_date).to be_invalid
      end

    end

  end

  describe "#begin_date" do

      it "creates a begin_date of type Date" do
        expect(subject.begin_date).to be_a_kind_of(Date)
      end

      it "converts the date string into a parsed data object" do
        expect(subject.begin_date.to_s).to eq '01/15/2014'
      end

  end

  describe "#end_date" do

      it "has an end_date" do
        expect(subject.end_date.to_s).to eq "05/20/2014"
      end

      it "converts the date string into a parsed data object" do
        expect(subject.end_date.to_s).to eq '05/20/2014'
      end

  end

  describe "#derive_begin_date" do

    it "given a prior end date resets the begin_date" do
        subject.derive_begin_date('20140804')
        expect(subject.begin_date.to_s).to eq '08/05/2014'
    end

  end

  describe "given three seasonal possibilities" do

    let(:spring_semester) { SemesterDateNormalizer.new(begin_date: '20140115', end_date: '20140520') }
    let(:summer_semester) { SemesterDateNormalizer.new(begin_date: '20140515', end_date: '20140820') }
    let(:fall_semester) { SemesterDateNormalizer.new(begin_date: '20140815', end_date: '20141220') }

    describe "#derive_semester_name" do

      context "when term is in the spring" do
        
        it "builds the correct spring name" do
          expect(spring_semester.derive_semester_name).to eq 'Spring 2014'
        end

      end

      context "when term is in the summer" do
        
        it "builds the correct summer name" do
          expect(summer_semester.derive_semester_name).to eq 'Summer 2014'
        end

      end

      context "when term is in the fall" do
        
        it "builds the correct fall name" do
          expect(fall_semester.derive_semester_name).to eq 'Fall 2014'
        end

      end


    end

    describe "#derive_code" do

      context "when term is in the spring" do

        it "sets the correct spring code" do
          expect(spring_semester.derive_code).to eq '201320'
        end

      end

      context "when term is in the summer" do

        it "sets the correct summer code" do
          expect(summer_semester.derive_code).to eq '201400'
        end

      end

      context "when term is in the fall" do

        it "sets the correct fall code" do
          expect(fall_semester.derive_code).to eq '201410'
        end

      end

    end
  end

end
