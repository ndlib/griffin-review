require 'spec_helper'


describe BookReserveImport do

  before(:each) do
    semester = FactoryGirl.create(:semester)

    stub_discovery!

    @api_data =  {"bib_id" => "generic","sid" => "NDU30-000047838-THEO-60853-01", "doc_number" => "000047839", "crosslist_id" => "crosslist_id", "section_group_id" => "current_multisection_crosslisted", "course_triple" => "201300_THEO_60853", "title" => "Blackwell Companion to Political Theology", 'format' => 'Book'}
    @course = double(Course, id: 'crosslist_id', semester: semester)
    BookReserveImport.any_instance.stub(:course).and_return(@course)
  end

  it "converts the bib id to have the ndu_aleph prefix" do
    expect(BookReserveImport.new(@api_data).bib_id).to eq("ndu_alephgeneric")
  end

  describe :new_reserve do
    before(:each) do
      @ibr = BookReserveImport.new(@api_data)
    end

    it "sets the reserve as being a physical reserve" do
      @ibr.import!
      expect(@ibr.reserve.physical_reserve).to be_true
    end


    it "imports a book that does not have an existing reserve to the course" do
      @ibr.import!
      expect(@ibr.reserve.request.new_record?).to be_false
    end


    it "sets the title of the book to be the data from the meta data service" do
      @ibr.import!
      expect(@ibr.reserve.title).to eq("Book.")
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
      expect(@ibr.reserve.type).to eq("BookReserve")
    end

    it "messages if it discovers an item that is not of the known format types"

  end


  describe :new_video_reserve do

    it "sets the item to be a video if it is a dvd" do
      @api_data['format'] = "DVD (visual)"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.reserve.type).to eq("VideoReserve")
    end

    it "sets the item to be a video if it is a cassette" do
      @api_data['format'] = "Video Cassette (visual)"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.reserve.type).to eq("VideoReserve")
    end

    it "sets videos to be both physical and electronic if electronic is nil" do
      @api_data['format'] = "Video Cassette (visual)"
      @ibr = BookReserveImport.new(@api_data)
      @ibr.import!

      expect(@ibr.reserve.electronic_reserve).to be_true
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

      expect(@ibr.errors).to eq(["format of not_a_format not found in the list of traped formats"])
    end
  end


  describe :existing_record do

    it "passes records that already exist" do
      @existing_reserve = mock_reserve FactoryGirl.create(:request, :inprocess, :item => FactoryGirl.create(:item_with_bib_record)), @course

      @ibr = BookReserveImport.new(@api_data)
      @ibr.reserve.should_receive(:save!).exactly(0).times

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
