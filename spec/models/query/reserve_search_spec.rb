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


  describe :reserve_by_bib_for_course do

    before(:each) do
      stub_discovery!
      @inprocess_semester = mock_reserve FactoryGirl.create(:request, :inprocess, :item => FactoryGirl.create(:item_with_bib_record)), @course
    end

    it "returns the reserve for the course that has a bib id" do
      reserve_search = ReserveSearch.new

      reserve = reserve_search.reserve_by_bib_for_course(@inprocess_semester.course, @inprocess_semester.nd_meta_data_id)
      expect(reserve.id).to be(@inprocess_semester.id)
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

      context :new do
        it "returns all the items in the passed in semester" do
          result = ReserveSearch.new.admin_requests('new', 'all', 'all', previous_semester)

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @new_semester2.id ])
        end

        it "returns all future  items when there is no semester passed in" do
          result = ReserveSearch.new.admin_requests('new', 'all', 'all')

          expect(result.size).to eq(2)
          expect(result.collect { | r | r.id }).to eq([ @new_semester1.id, @new_semester3.id ])
        end


        it "returns just the new ones for a specific library" do
          result = ReserveSearch.new.admin_requests('new', 'all', 'library1')

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @new_semester1.id ])
        end


        it "returns just the types asked for " do
          result = ReserveSearch.new.admin_requests('new', 'BookReserve', 'all')

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @new_semester1.id ])
        end
      end


      context :inprocess do

        it "returns all the items in the passed in semester" do
          result = ReserveSearch.new.admin_requests('inprocess', 'all', 'all', previous_semester)

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @inprocess_semester2.id ])
        end

        it "excludes items that are on order" do
          on_order_item = mock_reserve FactoryGirl.create(:request, :on_order, :inprocess, :library => 'library1', :semester_id => semester.id), @course
          result = ReserveSearch.new.admin_requests('inprocess', 'all', 'all', semester)

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @inprocess_semester1.id ])
        end

        it "includes on_order values of false" do
          @inprocess_semester1.on_order = false
          @inprocess_semester1.save!

          result = ReserveSearch.new.admin_requests('inprocess', 'all', 'all', semester)

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @inprocess_semester1.id ])
        end


        it "returns all future items when there is no semester passed in" do
          result = ReserveSearch.new.admin_requests('inprocess', 'all', 'all')

          expect(result.size).to eq(2)
          expect(result.collect { | r | r.id }).to eq([ @inprocess_semester1.id, @inprocess_semester3.id ])
        end


        it "returns just the new ones for a specific library" do
          result = ReserveSearch.new.admin_requests('inprocess', 'all', 'library1')

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @inprocess_semester1.id ])
        end


        it "returns just the types asked for " do
          result = ReserveSearch.new.admin_requests('inprocess', 'JournalReserve', 'all')

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @inprocess_semester1.id ])
        end
      end


      context :on_order do
        it "includes items that are on order" do
          on_order_item = mock_reserve FactoryGirl.create(:request, :on_order, :inprocess, :library => 'library1', :semester_id => semester.id), @course
          result = ReserveSearch.new.admin_requests('on_order', 'all', 'all', semester)

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ on_order_item.id ])
        end


      end


      context :available do

        it "returns all the items in the passed in semester" do
          result = ReserveSearch.new.admin_requests('available', 'all', 'all', previous_semester)

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @available_semester2.id ])
        end


        it "returns all future items when there is no semester passed in" do
          result = ReserveSearch.new.admin_requests('available', 'all', 'all')

          expect(result.size).to eq(2)
          expect(result.collect { | r | r.id }).to eq([ @available_semester1.id, @available_semester3.id ])
        end


        it "returns just the new ones for a specific library" do
          result = ReserveSearch.new.admin_requests('available', 'all', 'library1')

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @available_semester1.id ])
        end


        it "returns just the types asked for " do
          result = ReserveSearch.new.admin_requests('available', 'AudioReserve', 'all')

          expect(result.size).to eq(1)
          expect(result.collect { | r | r.id }).to eq([ @available_semester1.id ])
        end
      end


      describe :semester_only do

        it "returns all the reserves for the passed in semester " do
            result = ReserveSearch.new.admin_requests('all', 'all', 'all', previous_semester)

            expect(result.size).to eq(3)
            expect(result.collect { | r | r.id }).to eq([ @new_semester2.id, @inprocess_semester2.id, @available_semester2.id ])
        end

        it "returns all future reserves if no semester is passed in " do
            result = ReserveSearch.new.admin_requests('all', 'all', 'all')

            expect(result.size).to eq(6)
            expect(result.collect { | r | r.id }).to eq([ @new_semester1.id, @new_semester3.id, @inprocess_semester1.id, @inprocess_semester3.id, @available_semester1.id, @available_semester3.id ])
        end
      end


      describe :library_only do
        it "returns all the reserves for a library for the passed in " do
          result = ReserveSearch.new.admin_requests('all', 'all', 'library1', previous_semester)

          expect(result.size).to eq(3)
          expect(result.collect { | r | r.id }).to eq([ @new_semester2.id, @inprocess_semester2.id, @available_semester2.id ])
        end

        it "returns all the reserves for a library in the upcoming semesters" do
          result = ReserveSearch.new.admin_requests('all', 'all', 'library2')

          expect(result.size).to eq(3)
          expect(result.collect { | r | r.id }).to eq([ @new_semester3.id, @inprocess_semester3.id, @available_semester3.id ])
        end

        it "takes an array of availble library values" do
          result = ReserveSearch.new.admin_requests('all', 'all', [ 'library1', 'library2' ])

          expect(result.size).to eq(6)
        end
      end


      describe :type_only do
        it "returns all the reserves for a type for the passed in " do
          result = ReserveSearch.new.admin_requests('all', 'BookChapterReserve', 'all', next_semester)

          expect(result.size).to eq(3)
          expect(result.collect { | r | r.id }).to eq([ @new_semester3.id, @inprocess_semester3.id, @available_semester3.id ])
        end


        it "returns takes an array of reserve types" do
          result = ReserveSearch.new.admin_requests('all', ['BookReserve', 'AudioReserve'], 'all')

          expect(result.size).to eq(2)
        end
      end
    end
  end



end
