
describe PhysicalElectronicReserveForm do


  before(:each) do
    @course = double(Course, id: 'id')

    @reserve = double(Reserve, id: 'id', physical_reserve: true, electronic_reserve: true)
    @reserve.stub(:save!).and_return(true)
  end


  describe :initialize do

    it "sets reserve attributes to the virtus attributes" do
      @form = PhysicalElectronicReserveForm.new(@reserve, {})
      ['physical_reserve', 'electronic_reserve'].each do | attr |
        expect(@form.send(attr)).to be_truthy
      end
    end


    it "overwrites the values with what is in params" do
      params = { physical_reserve: false, electronic_reserve: false }
      @form = PhysicalElectronicReserveForm.new(@reserve, params)
      ['physical_reserve', 'electronic_reserve'].each do | attr |
        expect(@form.send(attr)).to be_falsey
      end
    end

  end


  describe :description_of_reserve_type do
    before(:each) do
      @reserve = double(Reserve, id: 'id', physical_reserve: false, physical_reserve?: false, electronic_reserve: false, electronic_reserve?: false)
      @form = PhysicalElectronicReserveForm.new(@reserve, {})
      @form.stub(:physical_reserve?).and_return(true)
      @form.stub(:electronic_reserve?).and_return(true)
    end

    it "returns the correct text if it is both physical and electronic" do
      expect(@form.description_of_reserve_type).to eq("Physical and Electronic Reserve")
    end


    it "returns the correct text if it is electronic" do
      @form.stub(:physical_reserve?).and_return(false)
      expect(@form.description_of_reserve_type).to eq("Electronic Reserve")
    end


    it "returns the correct text if it is physical" do
      @form.stub(:electronic_reserve?).and_return(false)
      expect(@form.description_of_reserve_type).to eq("Physical Reserve")
    end


    it "raises if the invalid state is reached" do
      @form.stub(:electronic_reserve?).and_return(false)
      @form.stub(:physical_reserve?).and_return(false)
      expect { @form.description_of_reserve_type }.to raise_error
    end
  end


  describe :persistance do
    before(:each) do
      @course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
      @reserve = Reserve.new(id: 'id', title: 'title', course: @course, type: 'BookChapterReserve', requestor_netid: 'netid', physical_reserve: false, electronic_reserve: false)
    end


    it "fails validation when both physical and electronic is false" do
      @form = PhysicalElectronicReserveForm.new(@reserve, {physical_reserve: false, electronic_reserve: false})
      expect(@form.valid?).to be_falsey
    end


    it "saves the reserve as an electroic " do
      @form = PhysicalElectronicReserveForm.new(@reserve, {physical_reserve: false, electronic_reserve: true})
      @form.update_reserve_type!

      expect(@form.reserve.electronic_reserve?).to be_truthy
    end


    it "saves the reserve as physical " do
      @form = PhysicalElectronicReserveForm.new(@reserve, {physical_reserve: true, electronic_reserve: false})
      @form.update_reserve_type!

      expect(@form.reserve.physical_reserve?).to be_truthy
    end
  end
end
