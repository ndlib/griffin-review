
describe LibraryReserveForm do

  before(:each) do
    @course = double(Course, id: 'id')

    @reserve = double(Reserve, id: 'id', library: 'hesburgh')
    @reserve.stub(:save!).and_return(true)
  end

  describe :initialize do

    it "sets reserve attributes to the virtus attributes" do
      @form = LibraryReserveForm.new(@reserve, {})
      expect(@form.send(:library)).to be_truthy
    end


    it "overwrites the value with what is in params" do
      params = { library: 'chem' }
      @form = LibraryReserveForm.new(@reserve, params)
      expect(@form.send(:library)).to eq 'chem'
    end

  end

  describe :persistance do
    before(:each) do
      @course = double(Course, id: 'id', semester: FactoryBot.create(:semester))
      @reserve = Reserve.new(id: 'id', title: 'title', course: @course, type: 'BookChapterReserve', requestor_netid: 'netid', physical_reserve: false, electronic_reserve: false, library: 'hesburgh')
    end

    it "saves the fulfillment library choice" do
      @form = LibraryReserveForm.new(@reserve, {library: 'chem'})
      @form.update_reserve_library!
      expect(@form.reserve.library).to eq 'chem'
    end

  end
end
