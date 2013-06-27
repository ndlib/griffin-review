require 'spec_helper'

describe ReserveListing do


  it "has a title" do
    ReserveListing.new(Reserve.new).respond_to?(:title)
  end

  it "has an id" do
    ReserveListing.new(Reserve.new).respond_to?(:id)
  end


  it "has a file" do
    ReserveListing.new(Reserve.new).respond_to?(:file)
  end


  it "has a course" do
    ReserveListing.new(Reserve.new).respond_to?(:course)
  end


  it "has a creator_contributor" do
    ReserveListing.new(Reserve.new).respond_to?(:creator_contributor)
  end


  it "has details" do
    ReserveListing.new(Reserve.new).respond_to?(:details)
  end


  it "has publisher_provider" do
    ReserveListing.new(Reserve.new).respond_to?(:publisher_provider)
  end


  it "determins if the resource should be linked to " do
    ReserveListing.new(Reserve.new).respond_to?(:link_to_get_listing?)
  end

  describe :css_class do
    it "determins what the listing css class should be" do
      ReserveListing.new(Reserve.new).respond_to?(:css_class)
    end

    it "sets the book class to when it is a book" do
      r = mock(Reserve, :type => 'BookReserve')
      ReserveListing.new(r).css_class.should == 'record-book'
    end

    it "sets the book chapter class to correctly when it is a book chapter" do
      r = mock(Reserve, :type => 'BookChapterReserve')
      ReserveListing.new(r).css_class.should == 'record-book'      
    end

    it "sets the video class to correctly when it is a video" do
      r = mock(Reserve, :type => 'VideoReserve')
      ReserveListing.new(r).css_class.should == 'record-video'
    end

    it "sets the audio class correctly when it is an audio reserve" do
      r = mock(Reserve, :type => 'AudioReserve')
      ReserveListing.new(r).css_class.should == 'record-audio'
    end

    it "sets the journal class correctly when it is a journal" do
      r = mock(Reserve, :type => 'JournalReserve')
      ReserveListing.new(r).css_class.should == 'record-journal'
    end
  end

end
