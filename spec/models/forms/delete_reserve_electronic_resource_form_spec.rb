

describe DeleteReserveElectronicResourceForm do


  before(:each) do
    @reserve = double(Reserve, id: 1, pdf: double("PDF"))
    @form = DeleteReserveElectronicResourceForm.new(@reserve)
  end

  describe :delete_link do

    it "returns the an <a tag" do
      expect(@form.delete_link).to eq("<a class=\"btn btn-danger\" data-confirm=\"Clicking &quot;ok&quot; will permamently remove any associated urls and uploaded files. Are you sure you wish to continue?\" data-method=\"delete\" href=\"/admin/resources/1\" id=\"delete_reserve_1\" rel=\"nofollow\"><i class=\"icon-remove\"></i> Delete Electronic Resource</a>")
    end
  end


  describe :remove! do

    it "removes the url, the file, and calls save " do
      @reserve.should_receive('url=')
      @reserve.pdf.should_receive(:clear)
      @reserve.should_receive(:save!)

      expect(@form.remove!).to be_true
    end
  end

end
