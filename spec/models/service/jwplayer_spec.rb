require 'spec_helper'

describe Jwplayer do
  subject { described_class.new(reserve, 'username', 'ipaddress') }

  context "blank file" do
    let(:rows) { [ { title: 'audio 1', file: '' } ] }
    let(:reserve) { double(Reserve, type: 'AudioResve', media_playlist: media_playlist )}
    let(:media_playlist) { double(MediaPlaylist, type: 'audio', rows: rows )}

    it "returns the jwplayer with a blank filename" do
      expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"http://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza-pprd-vm.library.nd.edu:1935/aod/_definst_/mp3:4sec.mp3?t=ea73a5472a75b69c6c4cfdd2cccf9e28\"},{\"file\":\"http://wowza-pprd-vm.library.nd.edu:1935/aod/_definst_/mp3:4sec.mp3/playlist.m3u8?t=572e341c3cdebfbd939870a66d6f79c4\"}],\"title\":\"audio 1\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"http://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":56});</script>")
    end

  end


  context "audio" do
    let(:reserve) { double(Reserve, type: 'AudioResve', media_playlist: media_playlist )}

    context "audio" do
      let(:rows) { [ { title: 'audio 1', file: 'C00139/C00139_0114.mp3' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'audio', rows: rows )}

      before(:each) do
        subject.stub(:rstp_url).and_return("http://url")
      end

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"http://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza.library.nd.edu:1935/aod/_definst_/mp3:C00139/C00139_0114.mp3?t=ed53bc094d75bb9fe8a19ca1c6d64d7e\"},{\"file\":\"http://wowza.library.nd.edu:1935/aod/_definst_/mp3:C00139/C00139_0114.mp3/playlist.m3u8?t=ed53bc094d75bb9fe8a19ca1c6d64d7e\"}],\"title\":\"audio 1\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"http://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":56});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"http://url\">Play Video</a></div>")
      end
    end


    context "audio" do
      let(:rows) { [ { title: 'audio 1', file: 'C00139/C00139_0114.mp3' }, { title: 'audio2', file: 'C00139/C00139_0114.mp3' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'audio', rows: rows )}

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"http://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza.library.nd.edu:1935/aod/_definst_/mp3:C00139/C00139_0114.mp3?t=efef6f62bfd1a773e5e5791e7d41b365\"},{\"file\":\"http://wowza.library.nd.edu:1935/aod/_definst_/mp3:C00139/C00139_0114.mp3/playlist.m3u8?t=efef6f62bfd1a773e5e5791e7d41b365\"}],\"title\":\"audio 1\"},{\"sources\":[{\"file\":\"rtmpt://wowza.library.nd.edu:1935/aod/_definst_/mp3:C00139/C00139_0114.mp3?t=efef6f62bfd1a773e5e5791e7d41b365\"},{\"file\":\"http://wowza.library.nd.edu:1935/aod/_definst_/mp3:C00139/C00139_0114.mp3/playlist.m3u8?t=efef6f62bfd1a773e5e5791e7d41b365\"}],\"title\":\"audio2\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"http://library.nd.edu\"},\"autostart\":false,\"width\":480,\"height\":480,\"listbar\":{\"position\":\"bottom\",\"size\":\"400\",\"layout\":\"basic\"}});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"http://url\">Play Video</a></div>")
      end
    end
  end

  context "video" do
    let(:reserve) { double(Reserve, type: 'VideoResve', media_playlist: media_playlist )}

    context "single" do
      let(:rows) { [ { title: 'video 1', file: 'filname.mov' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'video', rows: rows )}

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"http://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza.library.nd.edu:1935/vod/mp4:filname.mov?t=0379efd60d4b5d5a5ace08c2d40d8614\"},{\"file\":\"http://wowza.library.nd.edu:1935/vod/mp4:filname.mov/playlist.m3u8?t=0379efd60d4b5d5a5ace08c2d40d8614\"}],\"title\":\"video 1\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"http://library.nd.edu\"},\"autostart\":true,\"aspectratio\":\"16:9\",\"width\":\"80%\"});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"http://url\">Play Video</a></div>")
      end
    end


    context "double video" do
      let(:rows) { [ { title: 'video 1', file: 'filname.mov' }, { title: 'video 2', file: 'filename2' } ] }
      let(:media_playlist) { double(MediaPlaylist, type: 'video', rows: rows )}

      it "returns the jwplayer" do
        expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"http://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"playlist\":[{\"sources\":[{\"file\":\"rtmpt://wowza.library.nd.edu:1935/vod/mp4:filname.mov?t=32893b773ce3775fac6b9a6d55dea4c6\"},{\"file\":\"http://wowza.library.nd.edu:1935/vod/mp4:filname.mov/playlist.m3u8?t=32893b773ce3775fac6b9a6d55dea4c6\"}],\"title\":\"video 1\"},{\"sources\":[{\"file\":\"rtmpt://wowza.library.nd.edu:1935/vod/mp4:filname.mov?t=32893b773ce3775fac6b9a6d55dea4c6\"},{\"file\":\"http://wowza.library.nd.edu:1935/vod/mp4:filname.mov/playlist.m3u8?t=32893b773ce3775fac6b9a6d55dea4c6\"}],\"title\":\"video 2\"}],\"androidhls\":true,\"logo\":{\"file\":\"/assets/hesburgh.png\",\"link\":\"http://library.nd.edu\"},\"autostart\":true,\"aspectratio\":\"16:9\",\"width\":\"80%\",\"listbar\":{\"position\":\"right\",\"size\":\"20%\",\"layout\":\"basic\"}});</script>")
      end

      it "returns the rstp_link" do
        expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"http://url\">Play Video</a></div>")
      end
    end
  end
end
