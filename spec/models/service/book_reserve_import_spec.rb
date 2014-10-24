require 'spec_helper'


describe BookReserveImport do

  before(:each) do
    semester = FactoryGirl.create(:semester)

    stub_discovery!

    @api_data =  {"bib_id" => "generic","sid" => "NDU01-000047838-THEO-60853-01", "doc_number" => "000047839", "crosslist_id" => "crosslist_id", "section_group_id" => "current_multisection_crosslisted", "course_triple" => "201300_THEO_60853", "title" => "Blackwell Companion to Political Theology", 'format' => 'Book', 'creator' => 'creator', 'publisher' => 'publisher'}
    @course = double(Course, id: 'crosslist_id', semester: semester)
    BookReserveImport.any_instance.stub(:course).and_return(@course)
  end


  describe :new_reserve do
    before(:each) do
      @ibr = BookReserveImport.new(@api_data)
    end

    it "sets the reserve as being a physical reserve" do
      @ibr.import!
      expect(@ibr.reserves.first.physical_reserve).to be_true
    end


    it "sets the library to hesburgh" do
      @ibr.import!
      expect(@ibr.reserves.first.library).to eq("hesburgh")
    end

    it "imports a book that does not have an existing reserve to the course" do
      @ibr.import!
      expect(@ibr.reserves.first.request.new_record?).to be_false
    end


    it "sets a needed by date 2 weeks in the future" do
      @ibr.import!
      expect(@ibr.reserves.first.needed_by).to eq(2.weeks.from_now.to_date)
    end

    it "sets the title of the book to be the data from the meta data service" do
      @ibr.import!
      expect(@ibr.reserves.first.title).to eq("Book.")
    end

    it "syncs the meta data" do
      ReserveSynchronizeMetaData.any_instance.should_receive(:synchronize!)
      @ibr.import!
    end


    it "checks if the item is complete or not " do
      ReserveCheckIsComplete.any_instance.should_receive(:check!)
      @ibr.import!
    end

    it "makes a book reserve if the format is Book" do
      @ibr.import!
      expect(@ibr.reserves.first.type).to eq("BookReserve")
    end

    it "sets the reserve as being currently in aleph" do
      @ibr.import!
      expect(@ibr.reserves.first.currently_in_aleph).to be_true
    end

    it "sets the synchronization date" do
      @ibr.import!
      expect(@ibr.reserves.first.metadata_synchronization_date.to_s).to eq(Time.now.to_s)
    end


    it "messages if it discovers an item that is not of the known format types"

  end


  describe :new_non_catalog_reserve do

    before(:each) do
      @api_data["sid"] = "NDU30-000047838-THEO-60853-01"
      @ibr = BookReserveImport.new(@api_data)
    end

  end


  describe :new_video_reserve do

    it "sets the item to be a video if it is a dvd" do
      @api_data['format'] = "DVD (visual)"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.reserves.first.type).to eq("VideoReserve")
    end

    it "sets the item to be a video if it is a cassette" do
      @api_data['format'] = "Video Cassette (visual)"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.reserves.first.type).to eq("VideoReserve")
    end

    it "sets videos to be physical if electronic is nil" do
      @api_data['format'] = "Video Cassette (visual)"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.reserves.first.electronic_reserve).to be_false
    end

  end

  describe "Missing type" do

    it "returns false if this happens" do
      @api_data['format'] = "not a format"
      @ibr = BookReserveImport.new(@api_data)
      expect(@ibr.import!).to be_false
    end


    it "logs an error for this " do
      @api_data['format'] = "not_a_format"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.errors).to eq(["format of 'not_a_format' not found in the list of traped formats"])
    end
  end


  describe :existing_record do

    it "passes records that already exist" do
      @existing_reserve = mock_reserve FactoryGirl.create(:request, :inprocess, :item => FactoryGirl.create(:item_with_bib_record)), @course

      @ibr = BookReserveImport.new(@api_data)
      @ibr.reserves.first.should_receive(:save!).exactly(0).times

      @ibr.import!
    end

    it "does not overwrite an existing type or physical_reserve with BookReserve" do
      @existing_reserve = mock_reserve FactoryGirl.create(:request, :inprocess, :item => FactoryGirl.create(:item_with_bib_record, nd_meta_data_id: 'generic' )), @course
      @existing_reserve.type = 'BookReserve'
      @existing_reserve.physical_reserve = false
      @existing_reserve.save!

      BookReserveImport.any_instance.stub(:reserve).and_return(@existing_reserve)

      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      @existing_reserve.item.reload()
      expect(@existing_reserve.type).to eq("BookReserve")
      expect(@existing_reserve.physical_reserve).to be_false
    end


    it "does not set the videos to be electronic if the electronic is false" do
      @existing_reserve = mock_reserve FactoryGirl.create(:request, :inprocess, :item => FactoryGirl.create(:item_with_bib_record, nd_meta_data_id: 'generic' )), @course
      @existing_reserve.type = 'VideoReserve'
      @existing_reserve.electronic_reserve = false
      @existing_reserve.save!

      BookReserveImport.any_instance.stub(:reserve).and_return(@existing_reserve)

      @api_data['format'] = "DVD (visual)"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      @existing_reserve.item.reload()
      expect(@existing_reserve.type).to eq("VideoReserve")
      expect(@existing_reserve.electronic_reserve).to be_false
    end


    it "does not change an existing needed_by date" do
      @existing_reserve = mock_reserve FactoryGirl.create(:request, :inprocess, needed_by: 6.weeks.ago, :item => FactoryGirl.create(:item_with_bib_record, nd_meta_data_id: 'generic' )), @course
      @existing_reserve.type = 'BookReserve'
      @existing_reserve.physical_reserve = false
      @existing_reserve.save!

      BookReserveImport.any_instance.stub(:reserve).and_return(@existing_reserve)
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      @existing_reserve.item.reload()
      expect(@existing_reserve.needed_by).to eq(6.weeks.ago.to_date)
    end

  end


  describe :success? do

    it "can tell you if it was success full or not." do
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.success?).to be_true
    end

    it "can tell you if it failed" do
      @ibr = BookReserveImport.new(@api_data)
      @ibr.errors << "HI"

      expect(@ibr.success?).to be_false
    end
  end


  describe :errors do

    it "traps an error if the course cannot be found" do
      @api_data['crosslist_id'] = 'blabla'
      BookReserveImport.any_instance.stub(:course).and_return(nil)

      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!


      expect(@ibr.errors.first).to eq("Unable to find course #{@api_data['crosslist_id']}")
    end


    it "traps an error if the active record object does not save" do
      Request.any_instance.stub(:valid?).and_return(false)

      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.errors.first).to eq("Validation failed: ")
    end
  end

end
