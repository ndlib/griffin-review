
describe ElectronicReserve do

  context :is_electronic_reserve? do

    it "returns true if the reserve is electronic" do
      reserve = double(Reserve, electronic_reserve?: true)
      expect(ElectronicReserve.new(reserve).is_electronic_reserve?).to be_true
    end

    it "returns false if the reserve is not an electronic" do
      reserve = double(Reserve, electronic_reserve?: false)
      expect(ElectronicReserve.new(reserve).is_electronic_reserve?).to be_false
    end

  end
end
