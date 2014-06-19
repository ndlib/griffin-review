require 'spec_helper'

describe Jwplayer do
  let(:filename) { 'filename.mov' }
  subject { described_class.new(filename) }

  it "returns the jwplayer" do
    expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...</div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"flash\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"autostart\":true,\"sources\":[{\"file\":\"http://wowza.library.nd.edu:1935/vod/mp4:filename.mov/playlist.m3u8\"},{\"file\":\"rtmpt://wowza.library.nd.edu:1935/vod/mp4:filename.mov\"}]});</script>")
  end

  it "returns the rstp_link" do
    expect(subject.rstp_link).to eq("<a href=\"rtsp://wowza.library.nd.edu:1935/vod/mp4:filename.mov\">Play Video</a>")
  end

end
