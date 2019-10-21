
describe RequestTab do

  describe "new" do

    it "sets the new params" do
      arf = RequestTab.new('new')
      test_status_filter!('new', arf)
      test_css_class!('new', arf)

      "#{arf}".should == "new"
    end

  end


  describe "inprocess" do

    it "sets the inprocess params" do
      arf = RequestTab.new('inprocess')

      test_status_filter!('inprocess', arf)
      test_css_class!('inprocess', arf)

      "#{arf}".should == "inprocess"
    end
  end


  describe "on_order" do

    it "sets the on_order params" do
      arf = RequestTab.new('on_order')

      test_status_filter!('on_order', arf)
      test_css_class!('on_order', arf)

      "#{arf}".should == "on_order"
    end
  end


  describe "complete" do

    it "sets the complete params" do
      arf = RequestTab.new('available')
      test_status_filter!('available', arf)
      test_css_class!('available', arf)

      "#{arf}".should == "available"
    end
  end


  describe "removed" do
    it "sets the removed params" do
      arf = RequestTab.new('removed')
      test_status_filter!('removed', arf)
      test_css_class!('removed', arf)

      "#{arf}".should == "removed"
    end
  end


  describe "all" do
    it "sets the all params" do
      arf = RequestTab.new('all')
      test_status_filter!('all', arf)
      test_css_class!('all', arf)

      "#{arf}".should == "all"
    end
  end


  describe "not_in_aleph" do
    it "sets the not_in_aleph params" do
      arf = RequestTab.new('not_in_aleph')
      test_status_filter!('not_in_aleph', arf)
      test_css_class!('not_in_aleph', arf)

      "#{arf}".should == "not_in_aleph"
    end
  end


  describe "invalid filter" do

    it " raises an error if an ivalid filter is passed in " do
      lambda {
        RequestTab.new('asdfadsfafds')
      }.should raise_error
    end
  end

  describe 'self' do
    subject { described_class }

    describe '#statuses' do
      it 'is a list of all filters' do
        expect(subject.statuses).to eq(subject::VALID_FILTERS)
      end
    end
  end


  def test_status_filter!(filter, object)
    (RequestTab::VALID_FILTERS - [filter]).each do | f |
      expect(object.status_filter?(f)).to be_falsey
    end

    expect(object.status_filter?(filter)).to be_truthy
  end


  def test_css_class!(filter, object)
    (RequestTab::VALID_FILTERS - [filter]).each do | f |
      expect(object.css_class(f)).to eq("")
    end

    expect(object.css_class(filter)).to eq("active")
  end

end
