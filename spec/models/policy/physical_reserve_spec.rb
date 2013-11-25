

describe PhysicalReservePolicy do

  context :is_physical_reserve? do

    it "it returns true if the reserve is a physical_reserve?" do
      reserve = double(Reserve, physical_reserve?: true)
      expect(PhysicalReservePolicy.new(reserve).is_physical_reserve?).to be_true
    end

    it "returns false if the reserve is not a physical_reserve?" do
      reserve = double(Reserve, physical_reserve?: false)
      expect(PhysicalReservePolicy.new(reserve).is_physical_reserve?).to be_false
    end

  end
end
