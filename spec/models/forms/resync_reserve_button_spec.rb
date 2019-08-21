

describe ResyncReserveButton do


  describe :build_from_params do
    before(:each) do
      @controller = double(ApplicationController, params: { id: 1})
    end

    it "finds the reserve in the params" do
      ReserveSearch.any_instance.should_receive(:get).with(1)
      ResyncReserveButton.build_from_params(@controller)
    end


    it "returns an instance of ResyncReserveButton " do
      ReserveSearch.any_instance.stub(:get).and_return(double(Reserve, id: 1))
      expect(ResyncReserveButton.build_from_params(@controller).class).to eq(ResyncReserveButton)
    end

  end


  describe :can_be_resynced? do
    before(:each) do
      @reserve = double(Reserve, id: 1, nd_meta_data_id: nil, metadata_synchronization_date: nil)
    end

    it "returns true if there is a meta data id and a sync date" do
      @reserve.stub(:nd_meta_data_id).and_return('id')
      @reserve.stub(:metadata_synchronization_date).and_return(Time.now.to_s)

      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_truthy
    end

    it "returns false if it only has meta data id " do
      @reserve.stub(:nd_meta_data_id).and_return('id')

      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_falsey
    end


    it "returns false if it only has a sync date" do
      @reserve.stub(:metadata_synchronization_date).and_return(Time.now.to_s)

      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_falsey
    end


    it "returns false if there is no meta data and no sync date " do
      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_falsey
    end
  end


  describe :button do
    before(:each) do
      @reserve = double(Reserve, id: 1, overwrite_nd_meta_data: false)
      @button = ResyncReserveButton.new(@reserve)
    end


    it "returns a button if the reserve can be synched" do
      ResyncReserveButton.any_instance.stub(:can_be_resynced?).and_return(true)
      expect(@button.button).to eq("<a class=\"btn\" confirm=\"false\" rel=\"nofollow\" data-method=\"put\" href=\"/admin/resync/1\">Re-sync Meta Data</a>")
    end

    it "returns emptu sring if the the reserve cannot be synched " do
      ResyncReserveButton.any_instance.stub(:can_be_resynced?).and_return(false)
      expect(@button.button).to eq("")
    end

    it "sets a confirmation if the meta data has beeen overwritten" do
      ResyncReserveButton.any_instance.stub(:can_be_resynced?).and_return(true)
      @reserve.stub(:overwrite_nd_meta_data).and_return(true)

      expect(@button.button).to eq("<a class=\"btn\" confirm=\"The meta data has been manually edited clicking &quot;ok&quot; will overwrite those changes.\" rel=\"nofollow\" data-method=\"put\" href=\"/admin/resync/1\">Re-sync Meta Data</a>")
    end

  end


  describe :resync! do
    before(:each) do
      @reserve = double(Reserve, id: 1)
      @button = ResyncReserveButton.new(@reserve)
    end

    it "synchronizes the meta data" do
      ReserveSynchronizeMetaData.any_instance.should_receive(:synchronize!)
      @button.resync!
    end
  end

end
