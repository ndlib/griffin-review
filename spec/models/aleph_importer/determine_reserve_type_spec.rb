

describe AlephImporter::DetermineReserveType do

  before(:each) do
    @api_data = { 'format' => 'Book' }
    @api = AlephImporter::DetermineReserveType.new(@api_data)
  end

  describe :format do

    it "returns the format from the api data" do
      expect(@api.format).to eq("book")
    end


    it "downcases the format" do
      expect(@api_data['format']).to receive('downcase')
      @api.format
    end
  end


  describe :determine_type do

    it "determines BookReserve from Book " do
      expect(@api.determine_type).to eq("BookReserve")
    end


    it "determines BookReserve from 'Bound Serial' " do
      @api_data['format'] = 'Bound Serial'
      expect(@api.determine_type).to eq("BookReserve")
    end


    it "determines BookReserve from serial (unbound issue)" do
      @api_data['format'] = 'Serial (unbound issue)'
      expect(@api.determine_type).to eq("BookReserve")
    end


    it "determines VideoReserve from DVD (visual) " do
      @api_data['format'] = 'DVD (visual)'
      expect(@api.determine_type).to eq("VideoReserve")
    end


    it "determines VideoReserve from DVD (visual) " do
      @api_data['format'] = 'Video cassette (visual)'
      expect(@api.determine_type).to eq("VideoReserve")
    end


    it "determines VideoReserve from Digital Form (software, etc.) " do
      @api_data['format'] = 'Digital Form (software, etc.)'
      expect(@api.determine_type).to eq("VideoReserve")
    end


    it "determines AudioReserve from compact disc (sound recording) " do
      @api_data['format'] = 'Compact disc (sound recording)'
      expect(@api.determine_type).to eq("AudioReserve")
    end


    it "determines AudioReserve from audio (sound recordings) " do
      @api_data['format'] = 'Audio (sound recordings)'
      expect(@api.determine_type).to eq("AudioReserve")
    end


    it "determines BookReserve from score " do
      @api_data['format'] = 'score'
      expect(@api.determine_type).to eq("BookReserve")
    end


    it "determines AudioReserve from audio (sound recordings) " do
      @api_data['format'] = 'kit'
      expect(@api.determine_type).to eq("BookReserve")
    end


    it "determines BookReserve from score " do
      @api_data['format'] = 'graphic (2d pict., poster etc)'
      expect(@api.determine_type).to eq("BookReserve")
    end


    it "returns nil if the format is not found" do
      @api_data['format'] = 'something'
      expect(@api.determine_type).to be(nil)
    end
  end


  describe :determine_electronic_reserve do
    context :nil do
      before(:each) do
        @reserve = double(Reserve, electronic_reserve: nil)
      end


      it "returns true if the electronic_reserve has not been set and the type is VideoReserve" do
        @api.stub(:determine_type).and_return('VideoReserve')
        expect(@api.determine_electronic_reserve(@reserve)).to be(false)
      end

      it "returns true if the electronic_reserve has not been set and the type is AudioReserve" do
        @api.stub(:determine_type).and_return('VideoReserve')
        expect(@api.determine_electronic_reserve(@reserve)).to be(false)
      end

      it "returns true if the electronic_reserve has not been set and the type is BookReserve" do
        @api.stub(:determine_type).and_return('BookReserve')
        expect(@api.determine_electronic_reserve(@reserve)).to be(false)
      end
    end

    context :true do
      before(:each) do
        @reserve = double(Reserve, electronic_reserve: true)
      end

      it "returns true if the electronic_reserve has not been set" do
        expect(@api.determine_electronic_reserve(@reserve)).to be(true)
      end
    end

    context :false do
      before(:each) do
        @reserve = double(Reserve, electronic_reserve: false)
      end

      it "returns true if the electronic_reserve has not been set" do
        expect(@api.determine_electronic_reserve(@reserve)).to be(false)
      end
    end

  end
end
