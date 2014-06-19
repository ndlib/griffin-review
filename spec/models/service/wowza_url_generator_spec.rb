require 'spec_helper'

describe WowzaUrlGenerator do
  let(:filename) { 'filename.mov' }
  subject { described_class.new(filename) }


  it "returns html5 url " do
    expect(subject.html5).to eq("http://wowza.library.nd.edu:1935/vod/mp4:filename.mov/playlist.m3u8")
  end


  it "returns rtmp url" do
    expect(subject.rtmp).to eq("rtmpt://wowza.library.nd.edu:1935/vod/mp4:filename.mov")
  end


  it "returns rtsp url" do
    expect(subject.rtsp).to eq("rtsp://wowza.library.nd.edu:1935/vod/mp4:filename.mov")
  end
end
