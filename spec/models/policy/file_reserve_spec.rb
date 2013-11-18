
describe FileReserve do

  before(:each) do
    @reserve = double(Reserve, pdf: double())
  end

  it "returns true if the reserve pdf exists " do
    @reserve.pdf.stub(:present?).and_return(true)
    expect(FileReserve.new(@reserve).is_file_reserve?).to be_true
  end


  it "returns false if the reserve pdf does not exists " do
    @reserve.pdf.stub(:present?).and_return(false)
    expect(FileReserve.new(@reserve).is_file_reserve?).to be_false
  end


  context :redirect_url do
    it "is false" do
      expect(FileReserve.new(@reserve).redirect_url).to be_false
    end
  end


  context :file_path do
    it "returns the url if there is a streaming serveice url" do
      @reserve.pdf.stub(:file_path).and_return("path")
      FileReserve.any_instance.stub(:is_file_reserve?).and_return(true)
      expect(FileReserve.new(@reserve).file_path).to eq("path")
    end


    it "returns false if there is a streaming serveice url" do
      @reserve.pdf.stub(:file_path).and_return("path")
      FileReserve.any_instance.stub(:is_file_reserve?).and_return(false)
      expect(FileReserve.new(@reserve).file_path).to be_false
    end

  end
end

