require 'spec_helper'

describe WowzaUrlGenerator do
  let(:filename) { 'filename.mov' }
  let(:media_type) { 'video' }
  subject { described_class.new(filename, "username", "ipaddress", media_type) }

  describe "token generated" do
    before(:each) do
      subject.stub(:token).and_return("t=token")
    end

    it "returns html5 url " do
      expect(subject.html5).to eq("http://wowza-pprd-vm.library.nd.edu:1935/vod/mp4:filename.mov/playlist.m3u8?t=token")
    end


    it "returns rtmp url" do
      expect(subject.rtmp).to eq("rtmpt://wowza-pprd-vm.library.nd.edu:1935/vod/mp4:filename.mov?t=token")
    end


    it "returns rtsp url" do
      expect(subject.rtsp).to eq("rtsp://wowza-pprd-vm.library.nd.edu:1935/vod/mp4:filename.mov?t=token")
    end
  end

  describe "token passed in" do
    subject { described_class.new(filename, "username", "ipaddress", media_type, "passedintoken") }

    it "uses the token I specifically send in" do
      expect(subject.html5).to eq("http://wowza-pprd-vm.library.nd.edu:1935/vod/mp4:filename.mov/playlist.m3u8?t=passedintoken")
    end
  end
end
