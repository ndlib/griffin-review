require 'spec_helper'
Reserve

describe InstructorReserveRequest do

  let(:user) { mock(User, :username => 'instructor') }
  let(:course) { Course.new }

  before(:each) do
    @instructor_reserve = InstructorReserveRequest.new(user, course)
  end


  it "has the current user associated with it" do
    @instructor_reserve.current_user.should == user
  end


  describe "attributes" do

    it "has all the form attributes" do
      [
        :title, :publisher, :journal_title, :creator, :length, :note, :needed_by,
        :requestor_owns_a_copy, :requestor_has_an_electronic_copy, :library, :number_of_copies, :request_type
      ].each do | at |
        @instructor_reserve.respond_to?(at).should be_true
      end
    end
  end


  describe "validation" do

    describe "all types" do
      it "requires a title" do
        @instructor_reserve.should have(1).error_on(:title)
      end

      it "requires a needed_by" do
        @instructor_reserve.should have(1).error_on(:needed_by)
      end

      it "requires a library" do
        @instructor_reserve.should have(1).error_on(:library)
      end
    end

    describe "creator" do
      it "requires a creator if the type is Book, BookChapter, Journal, Audio" do
        ['BookReserve', 'BookChapterReserve', 'JournalReserve', 'AudioReserve'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should have(1).error_on(:creator)
        end
      end

      it "does not require a creator if the type is Video" do
        @instructor_reserve.type = 'VideoReserve'
        @instructor_reserve.should_not have(1).error_on(:creator)
      end
    end

    describe "length" do

      it "requires the lenght field if the type is BookChapter" do
        @instructor_reserve.type = 'BookChapterReserve'
        @instructor_reserve.should have(1).error_on(:length)
      end


      it "does not require the length for types: Book, Journal, Audio, Video" do
        ['BookReserve', 'VideoReserve', 'JournalReserve', 'AudioReserve'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should_not have(1).error_on(:length)
        end
      end
    end


    describe "journal_title" do

      it "requires the journal_title if the type is JournalReserve" do
        @instructor_reserve.type = 'JournalReserve'
        @instructor_reserve.should have(1).error_on(:journal_title)
      end


      it "does not requires the journal_title if the type is Book, BookChapter, Audio, Video" do
        ['BookReserve', 'VideoReserve', 'BookChapterReserve', 'AudioReserve'].each do | type |
          @instructor_reserve.type = type
          @instructor_reserve.should_not have(1).error_on(:journal_title)
        end

      end

    end
  end

end
