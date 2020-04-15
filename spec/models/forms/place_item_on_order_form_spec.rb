
describe PlaceItemOnOrderForm do

  describe :currently_on_order do

    before(:each) do
      @reserve = double(Reserve, id: 1)
      @form = PlaceItemOnOrderForm.new(@reserve)
    end

    it "#currently_on_order? is true" do
      @reserve.stub(on_order: true)
      expect(@form.currently_on_order?).to be_truthy
    end


    it "#currently_on_order? is false" do
      @reserve.stub(on_order: false)
      expect(@form.currently_on_order?).to be_falsey
    end
  end


  describe :can_place_on_order do

    before(:each) do
      @reserve = double(Reserve, id: 1)
      @form = PlaceItemOnOrderForm.new(@reserve)
    end

    it "returns true if the status is inprocess" do
      @reserve.stub(:workflow_state).and_return('inprocess')
      expect(@form.can_place_on_order?).to be_truthy
    end


    it "returns false for the other states" do
      ['new', 'completed', 'removed'].each do | state |
        @reserve.stub(:workflow_state).and_return(state)
        expect(@form.can_place_on_order?).to be_falsey
      end
    end

  end


  describe :button_title do
    before(:each) do
      @reserve = double(Reserve, id: 1)
      @form = PlaceItemOnOrderForm.new(@reserve)
    end

    it "returns the title for the button if the item is not on order " do
      @form.stub(:currently_on_order?).and_return(false)
      expect(@form.button_title).to eq("Item to be Purchased")
    end

    it "returns the title for the button if the item is not on order " do
      @form.stub(:currently_on_order?).and_return(true)
      expect(@form.button_title).to eq("Item Purchased")
    end
  end


  describe :toggle_on_order do
    before(:each) do
      CourseSearch.any_instance.stub(:get).and_return(double(Course, id: 1, semester: FactoryBot.create(:semester)))
      @reserve = Reserve.new(title: 'title', type: 'BookChapterReserve', requestor_netid: 'netid')

      @form = PlaceItemOnOrderForm.new(@reserve)
    end

    it "changes on_order = false to true " do
      @reserve.on_order = false
      @form.toggle_on_order!

      expect(@form.reserve.on_order).to be_truthy
    end


    it "changes on_order = nil to true " do
      @reserve.on_order = nil
      @form.toggle_on_order!

      expect(@form.reserve.on_order).to be_truthy
    end


    it "changes on_order = true to false" do
      @reserve.on_order = true
      @form.toggle_on_order!

      expect(@form.reserve.on_order).to be_falsey
    end
  end
end
