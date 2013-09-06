
describe AdminRequestFilter do


  describe "new" do

    it "sets the new params" do
      arf = AdminRequestFilter.new('new')
      test_set!('new', arf)
      test_css_class!('new', arf)

      "#{arf}".should == "new"
    end

  end


  describe "inprocess" do

    it "sets the inprocess params" do
      arf = AdminRequestFilter.new('inprocess')

      test_set!('inprocess', arf)
      test_css_class!('inprocess', arf)

      "#{arf}".should == "inprocess"
    end
  end


  describe "on_order" do

    it "sets the on_order params" do
      arf = AdminRequestFilter.new('on_order')

      test_set!('on_order', arf)
      test_css_class!('on_order', arf)

      "#{arf}".should == "on_order"
    end
  end


  describe "complete" do

    it "sets the complete params" do
      arf = AdminRequestFilter.new('available')
      test_set!('available', arf)
      test_css_class!('available', arf)

      "#{arf}".should == "available"
    end
  end


  describe "removed" do
    it "sets the removed params" do
      arf = AdminRequestFilter.new('removed')
      test_set!('removed', arf)
      test_css_class!('removed', arf)

      "#{arf}".should == "removed"
    end
  end


  describe "all" do
    it "sets the all params" do
      arf = AdminRequestFilter.new('all')
      test_set!('all', arf)
      test_css_class!('all', arf)

      "#{arf}".should == "all"
    end
  end


  describe "invalid filter" do

    it " raises an error if an ivalid filter is passed in " do
      lambda {
        AdminRequestFilter.new('asdfadsfafds')
      }.should raise_error
    end
  end


  def test_set!(filter, object)
    (AdminRequestFilter::VALID_FILTERS - [filter]).each do | f |
      expect(object.set?(f)).to be_false
    end

    expect(object.set?(filter)).to be_true
  end


  def test_css_class!(filter, object)
    (AdminRequestFilter::VALID_FILTERS - [filter]).each do | f |
      expect(object.css_class(f)).to eq("")
    end

    expect(object.css_class(filter)).to eq("active")
  end

end
