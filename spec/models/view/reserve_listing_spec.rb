require 'spec_helper'

describe ReserveRow do


  it "has a title" do
    ReserveRow.new(Reserve.new).respond_to?(:title)
  end

  it "has an id" do
    ReserveRow.new(Reserve.new).respond_to?(:id)
  end


  it "has a file" do
    ReserveRow.new(Reserve.new).respond_to?(:file)
  end


  it "has a course" do
    ReserveRow.new(Reserve.new).respond_to?(:course)
  end


  it "has a creator_contributor" do
    ReserveRow.new(Reserve.new).respond_to?(:creator_contributor)
  end


  it "has details" do
    ReserveRow.new(Reserve.new).respond_to?(:details)
  end


  it "has publisher_provider" do
    ReserveRow.new(Reserve.new).respond_to?(:publisher_provider)
  end


  it "determins if the resource should be linked to " do
    ReserveRow.new(Reserve.new).respond_to?(:link_to_get_listing?)
  end

  describe :css_class do
    it "determins what the listing css class should be" do
      ReserveRow.new(Reserve.new).respond_to?(:css_class)
    end

    it "sets the book class to when it is a book" do
      r = mock(Reserve, :type => 'BookReserve')
      ReserveRow.new(r).css_class.should == 'record-book'
    end

    it "sets the book chapter class to correctly when it is a book chapter" do
      r = mock(Reserve, :type => 'BookChapterReserve')
      ReserveRow.new(r).css_class.should == 'record-book'
    end

    it "sets the video class to correctly when it is a video" do
      r = mock(Reserve, :type => 'VideoReserve')
      ReserveRow.new(r).css_class.should == 'record-video'
    end

    it "sets the audio class correctly when it is an audio reserve" do
      r = mock(Reserve, :type => 'AudioReserve')
      ReserveRow.new(r).css_class.should == 'record-audio'
    end

    it "sets the journal class correctly when it is a journal" do
      r = mock(Reserve, :type => 'JournalReserve')
      ReserveRow.new(r).css_class.should == 'record-journal'
    end
  end

end
