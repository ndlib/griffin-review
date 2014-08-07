require 'spec_helper'

describe Jwplayer do
  let(:filename) { 'filename.mov' }
  subject { described_class.new(filename, 'username', 'ipaddress') }

  before(:each) do
    subject.stub(:sources).and_return([ "sources" ])
    subject.stub(:rstp_url).and_return("http://url")
  end

  it "returns the jwplayer" do
    expect(subject.jwplayer).to eq("<div id='jwplayer'>Loading the player...<h3>Troubleshooting</h3><ol><li>Check to see if you have <a href=\"http://get.adobe.com/flashplayer/\" target=\"_blank\">flash</a> installed.</li><li>We recommend using <a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"_blank\">Google Chrome</a></li></div><script type='text/javascript'>jwplayer('jwplayer').setup({\"fallback\":false,\"primary\":\"html5\",\"html5player\":\"/assets/jwplayer.html5.js\",\"flashplayer\":\"/assets/jwplayer.flash.swf\",\"autostart\":true,\"width\":\"100%\",\"aspectratio\":\"16:9\",\"androidhls\":true,\"playlist\":[{\"sources\":[\"sources\"]}]});</script>")
  end

  it "returns the rstp_link" do
    expect(subject.rstp_link).to eq("<div id='jwplayer'><a href=\"http://url\">Play Video</a></div>")
  end

end
