
describe RequestTab do

=begin
  before(:each) do
    @controller = ApplicationController.new
    @controller.stub(:current_user).and_return(double(User, id: 1, username: 'usernaem'))
    @controller.stub(:session).and_return({ } )
    @controller.stub(:params).and_return( { } )
  end

  describe :session_saving do

    it "saves the status value in the session when it is changed " do
      @controller.params[:admin_request_filter] = { status: 'inprocess', libraries: [ 'library1', 'library2'], types: [ 'types' ] }
      arf = RequestTab.new(@controller)

      expect(arf.filter).should eq("inprocess")
    end
  end

  describe :determine_filters do

    it "defaults to everything if there is nothing to choose from" do
      arf = RequestTab.new(@controller)
      expect(arf.filter).to eq("new")
      expect(arf.library_filters).to eq(RequestTab::VALID_LIBRARIES)
      expect(arf.library_filters).to eq(RequestTab::VALID_LIBRARIES)
    end


    it "defaults"
  end
=end

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


  describe "invalid filter" do

    it " raises an error if an ivalid filter is passed in " do
      lambda {
        RequestTab.new('asdfadsfafds')
      }.should raise_error
    end
  end


  def test_status_filter!(filter, object)
    (RequestTab::VALID_FILTERS - [filter]).each do | f |
      expect(object.status_filter?(f)).to be_false
    end

    expect(object.status_filter?(filter)).to be_true
  end


  def test_css_class!(filter, object)
    (RequestTab::VALID_FILTERS - [filter]).each do | f |
      expect(object.css_class(f)).to eq("")
    end

    expect(object.css_class(filter)).to eq("active")
  end

end
