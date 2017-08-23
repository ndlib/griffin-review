require 'spec_helper'

describe Jwplayer do
  subject { described_class.new(reserve, 'username', 'ipaddress') }

  context "blank file" do
    let(:rows) { [ { title: 'audio 1', file: '' } ] }
    let(:reserve) { double(Reserve, type: 'AudioResve', media_playlist: media_playlist )}
    let(:media_playlist) { double(MediaPlaylist, type: 'audio', rows: rows )}

    it "returns the jwplayer with a blank filename" do
      expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"https://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza-pprd.library.nd.edu:443/vod/?t=14c4b06b824ec593239362517f538b29mp3:StreamingAudio/MP3/4sec.mp3\"},{\"file\":\"https://wowza-pprd.library.nd.edu:443/vod/_definst_/mp3:StreamingAudio/MP3/4sec.mp3/playlist.m3u8?t=14c4b06b824ec593239362517f538b29\"}],\"title\":\"audio 1\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"https://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":56});</script>")
    end

  end


  context "audio" do
    let(:reserve) { double(Reserve, type: 'AudioResve', media_playlist: media_playlist )}

    context "audio" do
      let(:rows) { [ { title: 'audio 1', file: 'C00139/C00139_0114.mp3' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'audio', rows: rows )}

      before(:each) do
        subject.stub(:rstp_url).and_return("https://url")
      end

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"https://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza-pprd.library.nd.edu:443/vod/?t=14c4b06b824ec593239362517f538b29mp4:All Streamed Videos/C00139/C00139_0114.mp3\"},{\"file\":\"https://wowza-pprd.library.nd.edu:443/vod/_definst_/mp4:All Streamed Videos/C00139/C00139_0114.mp3/playlist.m3u8?t=14c4b06b824ec593239362517f538b29\"}],\"title\":\"audio 1\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"https://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":56});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"rtsp://wowza-pprd.library.nd.edu:443/vod/mp4:All Streamed Videos/C00139/C00139_0114.mp3?t=14c4b06b824ec593239362517f538b29\">audio 1</a></div>")
      end
    end


    context "audio" do
      let(:rows) { [ { title: 'audio 1', file: 'C00139/C00139_0114.mp3' }, { title: 'audio2', file: 'C00139/C00139_0114.mp3' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'audio', rows: rows )}

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"https://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza-pprd.library.nd.edu:443/vod/?t=14c4b06b824ec593239362517f538b29mp4:All Streamed Videos/C00139/C00139_0114.mp3\"},{\"file\":\"https://wowza-pprd.library.nd.edu:443/vod/_definst_/mp4:All Streamed Videos/C00139/C00139_0114.mp3/playlist.m3u8?t=14c4b06b824ec593239362517f538b29\"}],\"title\":\"audio 1\"},{\"sources\":[{\"file\":\"rtmpt://wowza-pprd.library.nd.edu:443/vod/?t=14c4b06b824ec593239362517f538b29mp4:All Streamed Videos/C00139/C00139_0114.mp3\"},{\"file\":\"https://wowza-pprd.library.nd.edu:443/vod/_definst_/mp4:All Streamed Videos/C00139/C00139_0114.mp3/playlist.m3u8?t=14c4b06b824ec593239362517f538b29\"}],\"title\":\"audio2\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"https://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":480,\"listbar\":{\"position\":\"bottom\",\"size\":\"422\",\"layout\":\"basic\"}});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"rtsp://wowza-pprd.library.nd.edu:443/vod/mp4:All Streamed Videos/C00139/C00139_0114.mp3?t=14c4b06b824ec593239362517f538b29\">audio 1</a><br><a href=\"rtsp://wowza-pprd.library.nd.edu:443/vod/mp4:All Streamed Videos/C00139/C00139_0114.mp3?t=14c4b06b824ec593239362517f538b29\">audio2</a></div>")
      end
    end
  end

  context "video" do
    let(:reserve) { double(Reserve, type: 'VideoResve', media_playlist: media_playlist )}

    context "single" do
      let(:rows) { [ { title: 'video 1', file: 'filname.mov' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'video', rows: rows )}

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"https://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza-pprd.library.nd.edu:443/vod/?t=14c4b06b824ec593239362517f538b29mp4:All Streamed Videos/filname.mov\"},{\"file\":\"https://wowza-pprd.library.nd.edu:443/vod/_definst_/mp4:All Streamed Videos/filname.mov/playlist.m3u8?t=14c4b06b824ec593239362517f538b29\"}],\"title\":\"video 1\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"https://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":56});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"rtsp://wowza-pprd.library.nd.edu:443/vod/mp4:All Streamed Videos/filname.mov?t=14c4b06b824ec593239362517f538b29\">video 1</a></div>")
      end
    end


    context "double video" do
      let(:rows) { [ { title: 'video 1', file: 'filname.mov' }, { title: 'video 2', file: 'filename2' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'video', rows: rows )}

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"https://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza-pprd.library.nd.edu:443/vod/?t=14c4b06b824ec593239362517f538b29mp4:All Streamed Videos/filname.mov\"},{\"file\":\"https://wowza-pprd.library.nd.edu:443/vod/_definst_/mp4:All Streamed Videos/filname.mov/playlist.m3u8?t=14c4b06b824ec593239362517f538b29\"}],\"title\":\"video 1\"},{\"sources\":[{\"file\":\"rtmpt://wowza-pprd.library.nd.edu:443/vod/?t=14c4b06b824ec593239362517f538b29mp4:All Streamed Videos/filename2\"},{\"file\":\"https://wowza-pprd.library.nd.edu:443/vod/_definst_/mp4:All Streamed Videos/filename2/playlist.m3u8?t=14c4b06b824ec593239362517f538b29\"}],\"title\":\"video 2\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"https://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":480,\"listbar\":{\"position\":\"bottom\",\"size\":\"422\",\"layout\":\"basic\"}});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"rtsp://wowza-pprd.library.nd.edu:443/vod/mp4:All Streamed Videos/filname.mov?t=14c4b06b824ec593239362517f538b29\">video 1</a><br><a href=\"rtsp://wowza-pprd.library.nd.edu:443/vod/mp4:All Streamed Videos/filename2?t=14c4b06b824ec593239362517f538b29\">video 2</a></div>")
      end
    end
  end
end
