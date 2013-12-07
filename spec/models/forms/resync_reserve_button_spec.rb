

describe ResyncReserveButton do


  describe :build_from_params do

  end


  describe :can_be_resynced? do
    before(:each) do
      @reserve = double(Reserve, id: 1, nd_meta_data_id: nil, metadata_synchronization_date: nil)
    end

    it "returns true if there is a meta data id and a sync date" do
      @reserve.stub(:nd_meta_data_id).and_return('id')
      @reserve.stub(:metadata_synchronization_date).and_return(Time.now.to_s)

      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_true
    end

    it "returns false if it only has meta data id " do
      @reserve.stub(:nd_meta_data_id).and_return('id')

      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_false
    end


    it "returns false if it only has a sync date" do
      @reserve.stub(:metadata_synchronization_date).and_return(Time.now.to_s)

      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_false
    end


    it "returns false if there is no meta data and no sync date " do
      expect(ResyncReserveButton.new(@reserve).can_be_resynced?).to be_false
    end
  end


  describe :button do
    before(:each) do
      @reserve = double(Reserve, id: 1)
      @button = ResyncReserveButton.new(@reserve)
    end


    it "returns a button if the reserve can be synched" do
      ResyncReserveButton.any_instance.stub(:can_be_resynced?).and_return(true)
      expect(@button.button).to eq("<a class=\"btn\" href=\"#\">Re-sync Meta Data</a>")
    end

    it "returns emptu sring if the the reserve cannot be synched " do
      ResyncReserveButton.any_instance.stub(:can_be_resynced?).and_return(false)
      expect(@button.button).to eq("")
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
