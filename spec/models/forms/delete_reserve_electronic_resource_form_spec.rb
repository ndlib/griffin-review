

describe DeleteReserveElectronicResourceForm do


  before(:each) do
    @reserve = double(Reserve, id: 1, pdf: double("PDF"), media_playlist: double(MediaPlaylist, destroy: true, present?: true), restart: true)
    @form = DeleteReserveElectronicResourceForm.new(@reserve)
  end

  describe :delete_link do

    it "returns the an <a tag" do
      expect(@form.delete_link).to eq("<a class=\"btn btn-danger\" data-confirm=\"Clicking &quot;ok&quot; will permamently remove any associated urls and uploaded files. Are you sure you wish to continue?\" data-method=\"delete\" href=\"/admin/resources/1\" id=\"delete_reserve_1\" rel=\"nofollow\"><i class=\"icon-remove\"></i> Delete Electronic Resource</a>")
    end
  end


  describe :remove! do

    it "removes the url, the file, calls save and checks that the item is still complete " do
      @reserve.should_receive('url=')
      @reserve.pdf.should_receive(:clear)
      @reserve.media_playlist.should_receive(:destroy)
      @reserve.should_receive(:save!)

      ReserveCheckIsComplete.any_instance.should_receive(:check!)

      expect(@form.remove!).to be_true
    end

  end

end
