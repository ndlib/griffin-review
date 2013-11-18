
describe StreamingReserve do

  context :is_streaming_reserve? do
    context :VideoReserve do
      before(:each) do
        @reserve = double(Reserve, type: 'VideoReserve', electronic_reserve?: false, physical_reserve?: false, url: nil )
      end

      it "returns true if it is an electronic reserve and an url" do
        @reserve.stub(:electronic_reserve?).and_return(true)
        @reserve.stub(:url).and_return("movie.mov")

        expect(StreamingReserve.new(@reserve).is_streaming_reserve?).to be_true
      end

      it "returns false if it is a physical reserve with an url" do
        @reserve.stub(:physical_reserve?).and_return(true)
        @reserve.stub(:url).and_return("movie.mov")

        expect(StreamingReserve.new(@reserve).is_streaming_reserve?).to be_false
      end

      it "return false if if is a physical resreve without an url " do
        @reserve.stub(:physical_reserve?).and_return(true)

        expect(StreamingReserve.new(@reserve).is_streaming_reserve?).to be_false
      end
    end

    context :AudioReserve do
      before(:each) do
        @reserve = double(Reserve, type: 'AudioReserve', electronic_reserve?: false, physical_reserve?: false, url: nil )
      end

      it "returns true if it is an electronic reserve and an url" do
        @reserve.stub(:electronic_reserve?).and_return(true)
        @reserve.stub(:url).and_return("movie.mov")

        expect(StreamingReserve.new(@reserve).is_streaming_reserve?).to be_true
      end

      it "returns false if it is a physical reserve with an url" do
        @reserve.stub(:physical_reserve?).and_return(true)
        @reserve.stub(:url).and_return("movie.mov")

        expect(StreamingReserve.new(@reserve).is_streaming_reserve?).to be_false
      end

      it "return false if if is a physical resreve without an url " do
        @reserve.stub(:physical_reserve?).and_return(true)

        expect(StreamingReserve.new(@reserve).is_streaming_reserve?).to be_false
      end
    end

    context :OtherReserve do
      before(:each) do
        @reserve = double(Reserve, type: 'BookReserve', electronic_reserve?: true, physical_reserve?: false, url: "url" )
      end

      it "returns true if it is an electronic reserve and an url" do
        expect(StreamingReserve.new(@reserve).is_streaming_reserve?).to be_false
      end
    end
  end


  context :streaming_service_redirect? do
    before(:each) do
      @reserve = double(Reserve)
    end

    it "returns true if the url has an http:// " do
      @reserve.stub(:url).and_return("http://url.com")
      expect(StreamingReserve.new(@reserve).streaming_service_redirect?).to be_true
    end

    it "returns true if the url has an https:// " do
      @reserve.stub(:url).and_return("https://url.com")
      expect(StreamingReserve.new(@reserve).streaming_service_redirect?).to be_true
    end

    it "returns false if the url does not have http[s]*://" do
      @reserve.stub(:url).and_return("url.mov")
      expect(StreamingReserve.new(@reserve).streaming_service_redirect?).to be_false
    end
  end


  context :redirect_url do
    before(:each) do
      @reserve = double(Reserve, url: "url")
    end

    it "returns the url if there is a streaming serveice url" do
      StreamingReserve.any_instance.stub(:streaming_service_redirect?).and_return(true)
      expect(StreamingReserve.new(@reserve).redirect_url).to eq("url")
    end


    it "returns false if there is a streaming serveice url" do
      StreamingReserve.any_instance.stub(:streaming_service_redirect?).and_return(false)
      expect(StreamingReserve.new(@reserve).redirect_url).to be_false
    end
  end


  context :download_file_path do
    before(:each) do
      @reserve = double(Reserve)
      MovFileGenerator.any_instance.stub(:mov_file_path).and_return("file")
    end

    it "returns the file if it is a streaming_resource" do
      StreamingReserve.any_instance.stub(:is_streaming_reserve?).and_return(true)
      expect(StreamingReserve.new(@reserve).file_path).to eq("file")
    end


    it "returns false if there is a streaming serveice url" do
      StreamingReserve.any_instance.stub(:is_streaming_reserve?).and_return(false)
      expect(StreamingReserve.new(@reserve).file_path).to be_false
    end
  end

end
