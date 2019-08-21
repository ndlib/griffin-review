require 'spec_helper'


describe ElectronicReservePolicy do

  before(:each) do
    @user = double(User, admin?: false)
    @pdf = double('PDF', present?: false, path: nil)
    @reserve = double(Reserve, id: 1, url: nil, pdf: @pdf, electronic_reserve?: false)

    @policy = ElectronicReservePolicy.new(@reserve)
  end


  describe :is_electronic_reserve? do
    it "returns true of the reserve is an electronic reserve" do
      @reserve.stub(:electronic_reserve?).and_return(true)
      expect(@policy.is_electronic_reserve?).to be_truthy
    end

    it "returns false if the reserve is not an electronic reserve" do
      expect(@policy.is_electronic_reserve?).to be_falsey
    end
  end


  describe :electronic_resource_type do
    before(:each) do
      @policy.stub(:has_file_resource?).and_return(false)
      @policy.stub(:has_streaming_resource?).and_return(false)
      @policy.stub(:has_url_resource?).and_return(false)
      @policy.stub(:has_sipx_resource?).and_return(false)
      @policy.stub(:has_media_playlist?).and_return(false)
      @policy.stub(:is_electronic_reserve?).and_return(false)
    end

    it "returns File if the type is file" do
      @policy.stub(:has_file_resource?).and_return(true)
      expect(@policy.electronic_resource_type).to eq("File")
    end

    it "returns Streaming Video if the type is streaming" do
      @policy.stub(:has_streaming_resource?).and_return(true)
      expect(@policy.electronic_resource_type).to eq("Streaming Video")
    end

    it "returns Streaming Video if the type is streaming" do
      @policy.stub(:has_sipx_resource?).and_return(true)
      expect(@policy.electronic_resource_type).to eq("SIPX")
    end

    it "returns Website Redirect if the type is url" do
      @policy.stub(:has_url_resource?).and_return(true)
      expect(@policy.electronic_resource_type).to eq("Website Redirect")
    end

    it "returns Media Playlist if the type is url" do
      @policy.stub(:has_media_playlist?).and_return(true)
      expect(@policy.electronic_resource_type).to eq("Media Playlist")
    end

    it "returns Not comleted if the item is electronic but not done" do
      @policy.stub(:is_electronic_reserve?).and_return(true)
      expect(@policy.electronic_resource_type).to eq("Not Completed")
    end

    it "returns empty string if the item is not electronic" do
      expect(@policy.electronic_resource_type).to eq("")
    end
  end


  describe :electronic_resource_name do
    before(:each) do
      @policy.stub(:has_file_resource?).and_return(false)
      @policy.stub(:has_streaming_resource?).and_return(false)
      @policy.stub(:has_url_resource?).and_return(false)
      @policy.stub(:has_sipx_resource?).and_return(false)
    end


    it "returns empty string if there is no resource" do
      expect(@policy.resource_name).to eq("")
    end

    it "returns the name of the file if there is a file attached" do
      @policy.stub(:has_file_resource?).and_return(true)
      @pdf.stub(:original_filename).and_return("original.file")

      expect(@policy.resource_name).to eq("original.file")
    end

    it "returns the type of medisa playlist if it is a media playlist" do
      @policy.stub(:has_media_playlist?).and_return(true)
      @reserve.stub(:type).and_return('AudioReserve')

      expect(@policy.resource_name).to eq("Audio")
    end

    it "returns the name of the streaming movie if there is a streaming movie" do
      @policy.stub(:has_streaming_resource?).and_return(true)
      @reserve.stub(:url).and_return("streaming.mov")

      expect(@policy.resource_name).to eq("streaming.mov")
    end

    it "returns the name of the sipx url if there is a sipx url" do
      @policy.stub(:has_sipx_resource?).and_return(true)
      @reserve.stub(:url).and_return("https://service.sipx.com")

      expect(@policy.resource_name).to eq("https://service.sipx.com")
    end


    it "returns the url if there is a url " do
      @policy.stub(:has_url_resource?).and_return(true)
      @reserve.stub(:url).and_return("url")

      expect(@policy.resource_name).to eq("url")
    end
  end


  describe :can_have_resource? do

    it "returns true if the reserve is an electronic reserve " do
      @policy.stub(:is_electronic_reserve?).and_return(true)
      expect(@policy.can_have_resource?).to be_truthy
    end

    it "returns false if the reserve is not an electronic reserve" do
      @policy.stub(:is_electronic_reserve?).and_return(false)
      expect(@policy.can_have_resource?).to be_falsey
    end
  end


  describe :can_have_file_resource? do
    context :electronic do |variable|
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(true)
      end


      it "returns true if the reserve is electronic" do
        expect(@policy.can_have_file_resource?).to be_truthy
      end


      it "returns true if no matter the type of the request as long as the reserves is electronic" do
        ['BookChapterReserve', 'BookReserve', 'JournalReserve', 'VideoReserve', 'AudioReserve'].each do | type |
          @reserve.stub(:type).and_return(type)
          expect(@policy.can_have_file_resource?).to be_truthy
        end
      end
    end

    context :physical_only_resource do
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(false)
      end


      it "returns false if the reserve is not electronic" do
        expect(@policy.can_have_file_resource?).to be_falsey
      end
    end
  end


  describe :can_have_url_resource? do
    context :electronic do |variable|
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(true)
      end


      it "returns true if the reserve is electronic" do
        expect(@policy.can_have_url_resource?).to be_truthy
      end


      it "returns true if no matter the type of the request as long as the reserves is electronic" do
        ['BookChapterReserve', 'BookReserve', 'JournalReserve', 'VideoReserve', 'AudioReserve'].each do | type |
          @reserve.stub(:type).and_return(type)
          expect(@policy.can_have_url_resource?).to be_truthy
        end
      end
    end

    context :physical_only_resource do
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(false)
      end


      it "returns false if the reserve is not electronic" do
        expect(@policy.can_have_url_resource?).to be_falsey
      end
    end
  end


  describe :can_have_sipx_resource? do
    context :electronic do |variable|
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(true)
      end


      it "returns true if the reserve is electronic" do
        expect(@policy.can_have_sipx_resource?).to be_truthy
      end


      it "returns true if no matter the type of the request as long as the reserves is electronic" do
        ['BookChapterReserve', 'BookReserve', 'JournalReserve', 'VideoReserve', 'AudioReserve'].each do | type |
          @reserve.stub(:type).and_return(type)
          expect(@policy.can_have_sipx_resource?).to be_truthy
        end
      end
    end

    context :physical_only_resource do
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(false)
      end


      it "returns false if the reserve is not electronic" do
        expect(@policy.can_have_sipx_resource?).to be_falsey
      end
    end
  end


  describe :can_have_streaming_resource? do
    context :electronic do |variable|
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(true)
      end


      it "returns true if the reserve is electronic and it is video or audio" do
        ['VideoReserve', 'AudioReserve'].each do | type |
          @reserve.stub(:type).and_return(type)
          expect(@policy.can_have_streaming_resource?).to be_truthy
        end
      end


      it "returns true if no matter the type of the request as long as the reserves is electronic" do
        ['BookChapterReserve', 'BookReserve', 'JournalReserve'].each do | type |
          @reserve.stub(:type).and_return(type)
          expect(@policy.can_have_streaming_resource?).to be_falsey
        end
      end
    end

    context :physical_only_resource do
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(false)
      end


      it "returns false if the reserve is not electronic" do
        expect(@policy.can_have_streaming_resource?).to be_falsey
      end
    end
  end


  describe :can_have_media_playlist? do
    context :electronic do |variable|
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(true)
      end


      it "returns true if the reserve is electronic and it is video or audio" do
        ['VideoReserve', 'AudioReserve'].each do | type |
          @reserve.stub(:type).and_return(type)
          expect(@policy.can_have_media_playlist?).to be_truthy
        end
      end


      it "returns true if no matter the type of the request as long as the reserves is electronic" do
        ['BookChapterReserve', 'BookReserve', 'JournalReserve'].each do | type |
          @reserve.stub(:type).and_return(type)
          expect(@policy.can_have_media_playlist?).to be_falsey
        end
      end
    end

    context :physical_only_resource do
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(false)
      end


      it "returns false if the reserve is not electronic" do
        expect(@policy.can_have_media_playlist?).to be_falsey
      end
    end
  end


  describe :has_resource? do
    before(:each) do
      @policy.stub(:has_url_resource?).and_return(false)
      @policy.stub(:has_file_resource?).and_return(false)
      @policy.stub(:has_streaming_resource?).and_return(false)
      @policy.stub(:has_sipx_resource?).and_return(false)
      @policy.stub(:has_media_playlist?).and_return(false)
    end

    it "is false if it does not have any resources" do
      expect(@policy.has_resource?).to be_falsey
    end

    it "is true if it has a url" do
      @policy.stub(:has_url_resource?).and_return(true)
      expect(@policy.has_resource?).to be_truthy
    end

    it "is true if it has a file" do
      @policy.stub(:has_file_resource?).and_return(true)
      expect(@policy.has_resource?).to be_truthy
    end

    it "is true if it has streaming" do
      @policy.stub(:has_streaming_resource?).and_return(true)
      expect(@policy.has_resource?).to be_truthy
    end

    it "is true if it has a media_playlist" do
      @policy.stub(:has_media_playlist?).and_return(true)
      expect(@policy.has_resource?).to be_truthy
    end

    it "is true if it has sipx" do
      @policy.stub(:has_sipx_resource?).and_return(true)
      expect(@policy.has_resource?).to be_truthy
    end
  end


  describe :has_file_resource? do

    context :can_have_file_resource do
      before(:each) do
        @policy.stub(:can_have_file_resource?).and_return(true)
        @policy.stub(:has_streaming_resource?).and_return(false)
      end

      it "returns true if the reserve has a file " do
        @pdf.stub(:present?).and_return(true)
        expect(@policy.has_file_resource?).to be_truthy
      end

      it "returns false if the reserve does not have a file" do
        expect(@policy.has_file_resource?).to be_falsey
      end
    end

    context :cannot_have_file_resource do
      before(:each) do
        @policy.stub(:can_have_file_resource?).and_return(false)
      end

      it "returns false if the reserve has a file " do
        @pdf.stub(:present?).and_return(true)
        expect(@policy.has_file_resource?).to be_falsey
      end

      it "returns false if the reserve does not have a file" do
        expect(@policy.has_file_resource?).to be_falsey
      end



    end
  end


  describe :has_url_resource? do

    context :can_have_url_resource do
      before(:each) do
        @policy.stub(:can_have_url_resource?).and_return(true)
      end

      it "returns true if the reserve has a url " do
        @reserve.stub(:url).and_return("url")
        expect(@policy.has_url_resource?).to be_truthy
      end

      it "returns false if the reserve url is nil" do
        expect(@policy.has_url_resource?).to be_falsey
      end

      it "returns false if the reserve url is empty " do
        @reserve.stub(:url).and_return("")
        expect(@policy.has_url_resource?).to be_falsey
      end
    end

    context :cannot_have_file_resource do
      before(:each) do
        @policy.stub(:can_have_url_resource?).and_return(false)
      end

      it "returns false if the reserve has a url " do
        @reserve.stub(:url).and_return("url")
        expect(@policy.has_url_resource?).to be_falsey
      end

      it "returns false if the reserve does not have a url" do
        expect(@policy.has_url_resource?).to be_falsey
      end
    end
  end


  describe :has_sipx_resource? do

    context :can_have_sipx_resource do
      before(:each) do
        @policy.stub(:can_have_sipx_resource?).and_return(true)
      end

      it "returns true if the reserve has a url " do
        @reserve.stub(:url).and_return("https://service.sipx.com")
        expect(@policy.has_sipx_resource?).to be_truthy
      end

      it "returns false if the url is not a sipx url" do
        @reserve.stub(:url).and_return("https://www.google.com")
        expect(@policy.has_sipx_resource?).to be_falsey
      end

      it "returns false if the reserve url is nil" do
        expect(@policy.has_sipx_resource?).to be_falsey
      end

      it "returns false if the reserve url is empty " do
        @reserve.stub(:url).and_return("")
        expect(@policy.has_sipx_resource?).to be_falsey
      end
    end

    context :cannot_have_sipx_resource do
      before(:each) do
        @policy.stub(:can_have_sipx_resource?).and_return(false)
      end

      it "returns false if the reserve has a url " do
        @reserve.stub(:url).and_return("url")
        expect(@policy.has_sipx_resource?).to be_falsey
      end

      it "returns false if the reserve does not have a url" do
        expect(@policy.has_sipx_resource?).to be_falsey
      end
    end
  end


  describe :has_streaming_resource? do
    context :can_have_streaming_resource do
      before(:each) do
        @policy.stub(:can_have_streaming_resource?).and_return(true)
      end

      it "returns true if the reserve has a url and it is a mov " do
        @reserve.stub(:url).and_return("movie.mov")
        expect(@policy.has_streaming_resource?).to be_truthy
      end

      it "returns false if the reserve has a redirect url" do
        @reserve.stub(:url).and_return("http://www.google.com")
        expect(@policy.has_streaming_resource?).to be_falsey
      end


      it "returns false if the reserve url is nil" do
        expect(@policy.has_streaming_resource?).to be_falsey
      end


      it "returns false if the reserve url is empty " do
        @reserve.stub(:url).and_return("")
        expect(@policy.has_streaming_resource?).to be_falsey
      end

    end

    context :cannot_have_file_resource do
      before(:each) do
        @policy.stub(:can_have_streaming_resource?).and_return(false)
      end


      it "returns true if the reserve has a url and it is a mov " do
        @reserve.stub(:url).and_return("movie.mov")
        expect(@policy.has_streaming_resource?).to be_falsey
      end


      it "returns false if the reserve does not have a url" do
        expect(@policy.has_streaming_resource?).to be_falsey
      end

    end
  end

  describe :has_media_playlist? do
    context :can_have_media_playlist do
      before(:each) do
        @policy.stub(:can_have_media_playlist?).and_return(true)
      end

      it "returns true if the media playlist is present" do
        @reserve.stub(:media_playlist).and_return(MediaPlaylist.new)
        expect(@policy.has_media_playlist?).to be_truthy
      end

      it "returns false if the media playlist is not present" do
        @reserve.stub(:media_playlist).and_return(nil)
        expect(@policy.has_media_playlist?).to be_falsey
      end
    end

    context :can_have_media_playlist do
      before(:each) do
        @policy.stub(:can_have_media_playlist?).and_return(false)
      end

      it "returns false if the media playlist is present" do
        @reserve.stub(:media_playlist).and_return(MediaPlaylist.new)
        expect(@policy.has_media_playlist?).to be_falsey
      end

      it "returns false if the media playlst is not present" do
        @reserve.stub(:media_playlist).and_return(nil)
        expect(@policy.has_media_playlist?).to be_falsey
      end
    end
  end


  describe :redirect_url do
    before(:each) do
      @reserve.stub(:url).and_return("url")
    end

    context :has_url_resource do
      it "returns the url" do
        @policy.stub(:has_url_resource?).and_return(true)
        expect(@policy.redirect_url).to eq("url")
      end
    end

    context :does_not_have_resource do
      it "returns false" do
        @policy.stub(:has_url_resource?).and_return(false)
        expect(@policy.redirect_url).to be_falsey
      end
    end
  end


  describe :download_file_path do
    before(:each) do
      @pdf.stub(:path).and_return("/file/path")
    end

    context :has_file do

      it "returns the file path" do
        @policy.stub(:has_file_resource?).and_return(true)
        expect(@policy.download_file_path).to eq("/file/path")
      end
    end

    context :no_file do
      it "returns the false" do
        @policy.stub(:has_file_resource?).and_return(false)
        expect(@policy.download_file_path).to be_falsey
      end
    end
  end


  describe :streaming_download_file do

    context :has_file do

      it "returns the file path" do
        @policy.stub(:has_streaming_resource?).and_return(true)
        @reserve.stub(:url).and_return("/file/path")

        expect(@policy.streaming_download_file).to eq("/file/path")
      end
    end

    context :no_file do
      it "returns the false" do
        @policy.stub(:has_streaming_resource?).and_return(false)
        expect(@policy.streaming_download_file).to be_falsey
      end
    end
  end



  describe :complete? do
    context :electronic_reserve do
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(true)
      end


      it "returns true if the item can have resources and it has a resource " do
        @policy.stub(:has_resource?).and_return(true)
        expect(@policy.complete?).to be_truthy
      end


      it "returns false if the item can have resources and it does not have a resource" do
        @policy.stub(:has_resource?).and_return(false)
        expect(@policy.complete?).to be_falsey
      end
    end

    context :physical_only_resource do
      before(:each) do
        @policy.stub(:is_electronic_reserve?).and_return(false)
      end


      it "returns true if the item cannot have resources" do
        expect(@policy.complete?).to be_truthy
      end
    end
  end

end
