
describe UrlReserve do

  before(:each) do
    @reserve = double(Reserve)
  end

  it "returns true if the url has an http:// " do
    @reserve.stub(:url).and_return("http://url.com")
    expect(UrlReserve.new(@reserve).is_url_reserve?).to be_true
  end

  it "returns true if the url has an https:// " do
    @reserve.stub(:url).and_return("https://url.com")
    expect(UrlReserve.new(@reserve).is_url_reserve?).to be_true
  end

  it "returns false if the url does not have http[s]*://" do
    @reserve.stub(:url).and_return("url.mov")
    expect(UrlReserve.new(@reserve).is_url_reserve?).to be_false
  end

  it "returns false if it is not set" do
    @reserve.stub(:url).and_return("")
    expect(UrlReserve.new(@reserve).is_url_reserve?).to be_false
  end


  it "returns false if it is nil" do
    @reserve.stub(:url).and_return(nil)
    expect(UrlReserve.new(@reserve).is_url_reserve?).to be_false
  end


  context :redirect_url do
    before(:each) do
      @reserve = double(Reserve, url: "url")
    end

    it "returns the url if there is a streaming serveice url" do
      UrlReserve.any_instance.stub(:is_url_reserve?).and_return(true)
      expect(UrlReserve.new(@reserve).redirect_url).to eq("url")
    end


    it "returns false if there is a streaming serveice url" do
      UrlReserve.any_instance.stub(:is_url_reserve?).and_return(false)
      expect(UrlReserve.new(@reserve).redirect_url).to be_false
    end
  end


  context :file_path do

    it "is false" do
      expect(UrlReserve.new(@reserve).file_path).to be_false
    end
  end
end

