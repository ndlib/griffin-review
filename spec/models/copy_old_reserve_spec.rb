require 'spec_helper'

describe CopyReserve do

  let(:semester) { FactoryGirl.create(:semester) }
  let(:user) { mock_model(User, id: 1, username: 'username' )}
  let(:to_course) { double(Course, id: 'course_id', semester: semester, crosslist_id: 'crosslist_id') }

  describe :generic_copy do
    before(:each) do
      old_reserve = mock_model(OpenItem, item_type: 'chapter', location: 'test.pdf', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "1 - 2", journal_name: "journal", group_name: "Admin" )
      @new_reserve = CopyOldReserve.new(user, to_course, old_reserve).copy
    end

    it "sets reviewed to be true " do
      expect(@new_reserve.reviewed?).to be_true
    end

    it "sets the book chapter title" do
      @new_reserve.title.should == "title"
    end


    it "sets the workflow state to new " do
      @new_reserve.workflow_state.should == "new"
    end


    it "sets the creator of the work" do
      @new_reserve.creator.should == "fname lname"
    end


    it "sets the overwrite_nd_meta_data to true" do
      @new_reserve.overwrite_nd_meta_data?.should be_true
    end


    it "sets the journal_title" do
      @new_reserve.journal_title.should == "journal"
    end


    it "sets the pages " do
      @new_reserve.length.should == "1 - 2"
    end


    it "sets a needed by date 2 weeks into the future" do
      expect(@new_reserve.needed_by).to eq(2.weeks.from_now.to_date)
    end

  end


  describe :copy_book do
    before(:each) do
      @old_reserve = mock_model(OpenItem, item_type: 'book', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "", journal_name: "", sourceId: 'sid', group_name: "Admin"  )
      API::PrintReserves.stub(:find_by_rta_id_course_id).and_return([ {'bib_id' => 'bib_id' } ])
      ReserveSynchronizeMetaData.any_instance.stub(:discovery_record).and_return(double(DiscoveryApi, title: 'title', creator_contributor: 'creator', publisher_provider: 'publisher', details: 'details', type: 'book'))
    end

    it "sets the type correctly" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.type.should == "BookReserve"
    end


    it "sets the realtime availabliity id " do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.realtime_availability_id.should == "sid"
    end

    it "should auto complete this reserve" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.workflow_state.should == "new"
    end

    it "should look up the nd_meta_data_id for this item" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.nd_meta_data_id).to eq("bib_id")
    end

    it "should attempt to synchonize the metadata " do
      ReserveSynchronizeMetaData.any_instance.should_receive(:synchronize!)
      CopyOldReserve.new(user, to_course, @old_reserve).copy
    end

    it "should say that the metadata is overwriten" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.overwrite_nd_meta_data).to be_false
    end
  end


  describe :copy_book_chapter do
    before(:each) do
      old_reserve = mock_model(OpenItem, item_type: 'chapter', location: 'test.pdf', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "1 - 2", journal_name: "", group_name: "Admin"  )

      @new_reserve = CopyOldReserve.new(user, to_course, old_reserve).copy
    end

    it "sets a pdf for download" do
      @new_reserve.pdf.present?.should be_true
    end


    it "sets the type correctly " do
      @new_reserve.type.should == "BookChapterReserve"
    end


    it "should not auto complete this reserve" do
      @new_reserve.workflow_state.should == "new"
    end
  end


  describe :copy_book_chapter_with_chapter_title do
    before(:each) do
      old_reserve = mock_model(OpenItem, item_type: 'chapter', location: 'test.pdf', book_title: 'book_title', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "1 - 2", journal_name: "", group_name: "Admin")
      @new_reserve = CopyOldReserve.new(user, to_course, old_reserve).copy
    end


    it "sets the selection_title with the chapter title" do
      expect(@new_reserve.selection_title).to eq("title")
      expect(@new_reserve.title).to eq("book_title")
    end
  end


  describe :copy_journal do
    before(:each) do
      @old_reserve = mock_model(OpenItem, item_type: 'article', location: 'test.pdf', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "1 - 2", journal_name: "", group_name: "Admin"  )
    end

    it "sets the type correctly for articles" do
      new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      new_reserve.type.should == "JournalReserve"
    end


    it "sets the type correctly for journals" do
      @old_reserve.stub(:item_type).and_return('journal')
      new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      new_reserve.type.should == "JournalReserve"
    end


    it "gets a pdf when the article has a pdf associated with it" do
      new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      new_reserve.pdf.present?.should be_true
    end


    it "should not auto complete a journal file " do
      new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      new_reserve.workflow_state.should == "new"
    end



    it "copies a url when the article has a url" do
      @old_reserve.stub(:location).and_return('')
      @old_reserve.stub(:url).and_return('http://www.google.com')

      new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      new_reserve.url.should == 'http://www.google.com'
    end


    it "should auto complete a journal url " do
      @old_reserve.stub(:location).and_return('')
      @old_reserve.stub(:url).and_return('http://www.google.com')

      new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      new_reserve.workflow_state.should == "available"
    end
  end



  describe :copy_video do
    before(:each) do
      @old_reserve = mock_model(OpenItem, item_type: 'video', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "", journal_name: "", sourceId: 'sid', group_name: "Admin"  )
      API::PrintReserves.stub(:find_by_rta_id_course_id).and_return([ {'bib_id' => 'bib_id' } ])
      ReserveSynchronizeMetaData.any_instance.stub(:discovery_record).and_return(double(DiscoveryApi, title: 'title', creator_contributor: 'creator', publisher_provider: 'publisher', details: 'details', fulltext_available?: false, type: 'book'))
    end

    it "sets the type correctly" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.type.should == "VideoReserve"
    end


    it "sets the realtime availabliity id " do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.realtime_availability_id.should == "sid"
    end


    it "should not auto complete a video reserve" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.workflow_state.should == "new"
    end


    it "should look up the nd_meta_data_id for this item" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.nd_meta_data_id).to eq("bib_id")
    end


    it "should attempt to synchonize the metadata " do
      ReserveSynchronizeMetaData.any_instance.should_receive(:synchronize!)
      CopyOldReserve.new(user, to_course, @old_reserve).copy
    end


    it "should say that the metadata is overwriten" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.overwrite_nd_meta_data).to be_false
    end

  end




  describe :copy_music do
    before(:each) do
      @old_reserve = mock_model(OpenItem, item_type: 'music', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "", journal_name: "", sourceId: 'sid', group_name: "Admin"  )
      API::PrintReserves.stub(:find_by_rta_id_course_id).and_return([ {'bib_id' => 'bib_id' } ])
      ReserveSynchronizeMetaData.any_instance.stub(:discovery_record).and_return(double(DiscoveryApi, title: 'title', creator_contributor: 'creator', publisher_provider: 'publisher', details: 'details', fulltext_available?: false, type: 'book'))
    end

    it "sets the type correctly" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.type.should == "AudioReserve"
    end


    it "sets the realtime availabliity id " do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.realtime_availability_id.should == "sid"
    end


    it "should not auto complete a video reserve" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      @new_reserve.workflow_state.should == "new"
    end


    it "should say that the metadata is overwriten" do
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.overwrite_nd_meta_data).to be_false
    end


    it "should attempt to synchonize the metadata " do
      ReserveSynchronizeMetaData.any_instance.should_receive(:synchronize!)
      CopyOldReserve.new(user, to_course, @old_reserve).copy
    end
  end



  describe :convert_group_name_to_library do
    before(:each) do
      @old_reserve = mock_model(OpenItem, item_type: 'chapter', title: "title", author_firstname: "fname", author_lastname: "lname", pages: "", journal_name: "", sourceId: 'sid', group_name: ""  )
    end

    it "converts admin to hesburgh" do
      @old_reserve.stub(:group_name).and_return 'Admin'
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.library).to eq('hesburgh')
    end

    it "converts Mathamtics to math" do
      @old_reserve.stub(:group_name).and_return 'Mathematics'
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.library).to eq('math')
    end


    it "converts Chemistry/Phyics to chem" do
      @old_reserve.stub(:group_name).and_return 'Chemistry/Physics'
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.library).to eq('chem')
    end


    it "converts Business to business" do
      @old_reserve.stub(:group_name).and_return 'Business'
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.library).to eq('business')
    end


    it "converts Engineering to engineering" do
      @old_reserve.stub(:group_name).and_return 'Engineering'
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.library).to eq('engineering')
    end


    it "converts Architecture to architecture" do
      @old_reserve.stub(:group_name).and_return 'Architecture'
      @new_reserve = CopyOldReserve.new(user, to_course, @old_reserve).copy
      expect(@new_reserve.library).to eq('architecture')
    end
  end
end
