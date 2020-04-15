
describe NeededByReserveForm do

  before(:each) do
    @course = double(Course, id: 'id')

    @reserve = double(Reserve, id: 'id', needed_by: '2051-01-15')
    @reserve.stub(:save!).and_return(true)
  end

  describe :initialize do

    it "sets reserve attributes to the virtus attributes" do
      @form = NeededByReserveForm.new(@reserve, {})
      expect(@form.send(:needed_by)).to be_truthy
    end


    it "overwrites the value with what is in params" do
      params = { needed_by: '2045-01-20' }
      @form = NeededByReserveForm.new(@reserve, params)
      expect(@form.send(:needed_by)).to eq '2045-01-20'
    end

  end

  describe :persistance do
    before(:each) do
      @course = double(Course, id: 'id', semester: FactoryBot.create(:semester))
      @reserve = Reserve.new(id: 'id', title: 'title', course: @course, type: 'BookChapterReserve', requestor_netid: 'netid', physical_reserve: false, electronic_reserve: false, library: 'hesburgh')
    end

    it "saves the needed by date" do
      @form = NeededByReserveForm.new(@reserve, {needed_by: '2031-03-14'})
      @form.update_reserve_needed_by!
      expect(@form.reserve.needed_by).to eq 'Fri, 14 Mar 2031'.to_date
    end

  end
end
