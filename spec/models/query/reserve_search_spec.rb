require 'spec_helper'

describe ReserveSearch do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:previous_semester) { FactoryGirl.create(:previous_semester) }
  let(:next_semester) { FactoryGirl.create(:next_semester) }

  let(:course_search) { CourseSearch.new }

  before(:each) do
    @course = double(Course, id: 'crosslist_id', semester: semester)
  end

  describe :student_and_instructor_requests do

    before(:each) do
      @new_reserve       = mock_reserve FactoryGirl.create(:request, :new, :book), @course
      @inprogress_reserve = mock_reserve FactoryGirl.create(:request, :inprocess, :book), @course
      @available_reserve = mock_reserve FactoryGirl.create(:request, :available, :book), @course
    end


    describe :instructor_reserves_for_course do

      it "returns all the reserves for a course" do
        reserve_search = ReserveSearch.new
        reserve_search.instructor_reserves_for_course(@course).size.should == 3
      end


      it "returns the reserves in alphabetical order" do
        reserve_search = ReserveSearch.new
        reserve_search.instructor_reserves_for_course(@course).collect{|r| r.id}.should == [@new_reserve.id, @inprogress_reserve.id, @available_reserve.id]
      end
    end


    describe :student_reserves_for_course do

      it "returns only the reserves that are visible to students" do
        reserve_search = ReserveSearch.new
        reserve_search.student_reserves_for_course(@course).size.should == 1
      end

    end

    describe :get do

      it "gets the reserve with the id " do
        reserve_search = ReserveSearch.new
        reserve_search.get(@inprogress_reserve.id, @course).id.should == @inprogress_reserve.id
      end


      it "returns nil if the record is not found" do
        reserve_search = ReserveSearch.new
        lambda {
          reserve_search.get(2342342, @course)
        }.should raise_error ActiveRecord::RecordNotFound

      end
    end

  end


  describe :reserves_by_bib_for_course do

    before(:each) do
      stub_discovery!
      @inprocess_semester = mock_reserve FactoryGirl.create(:request, :inprocess, :item => FactoryGirl.create(:item_with_bib_record)), @course
    end

    it "returns the reserve for the course that has a bib id" do
      reserve_search = ReserveSearch.new

      reserve = reserve_search.reserves_by_bib_for_course(@inprocess_semester.course, @inprocess_semester.nd_meta_data_id)
      expect(reserve.first.id).to be(@inprocess_semester.id)
    end

  end


  describe :admin_reserve_requests do
    before(:each) do
      @new_semester1 = mock_reserve FactoryGirl.create(:request, :book, :new, :library => 'library1', :semester_id => semester.id), @course
      @new_semester2 = mock_reserve FactoryGirl.create(:request, :journal_file, :new, :library => 'library1', :semester_id => previous_semester.id), @course
      @new_semester3 = mock_reserve FactoryGirl.create(:request, :book_chapter, :new, :library => 'library2', :semester_id => next_semester.id), @course

      @inprocess_semester1 = mock_reserve FactoryGirl.create(:request, :journal_url, :inprocess, :library => 'library1', :semester_id => semester.id), @course
      @inprocess_semester2 = mock_reserve FactoryGirl.create(:request, :video, :inprocess, :library => 'library1', :semester_id => previous_semester.id), @course
      @inprocess_semester3 = mock_reserve FactoryGirl.create(:request, :book_chapter, :inprocess, :library => 'library2', :semester_id => next_semester.id), @course

      @available_semester1 = mock_reserve FactoryGirl.create(:request, :audio, :available, :library => 'library1', :semester_id => semester.id), @course
      @available_semester2 = mock_reserve FactoryGirl.create(:request, :book, :available, :library => 'library1', :semester_id => previous_semester.id), @course
      @available_semester3 = mock_reserve FactoryGirl.create(:request, :book_chapter, :available, :library => 'library2', :semester_id => next_semester.id), @course
    end





    describe :admin_reserve_requests_by_status_for_semester do

      describe :semester_only do

        it "returns all the reserves for the passed in semester " do
            result = ReserveSearch.new.admin_requests(previous_semester)

            expect(result.size).to eq(3)
            expect(result.collect { | r | r.id }).to eq([ @new_semester2.id, @inprocess_semester2.id, @available_semester2.id ])
        end

        it "returns all future reserves if no semester is passed in " do
            result = ReserveSearch.new.admin_requests()

            expect(result.size).to eq(6)
            expect(result.collect { | r | r.id }).to eq([ @new_semester1.id, @new_semester3.id, @inprocess_semester1.id, @inprocess_semester3.id, @available_semester1.id, @available_semester3.id ])
        end
      end
    end
  end



end
