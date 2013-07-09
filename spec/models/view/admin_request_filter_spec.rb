
describe AdminRequestFilter do


  describe "new" do

    it "sets the new params" do
      arf = AdminRequestFilter.new('new')
      arf.inprocess?.should be_false
      arf.complete?.should be_false

      arf.inprocess_css_class.should == ""

      "#{arf}".should == "new"
    end

  end


  describe "inprocess" do

    it "sets the inprocess params" do
      arf = AdminRequestFilter.new('inprocess')
      arf.inprocess?.should be_true
      arf.complete?.should be_false

      arf.inprocess_css_class.should == "active"

      "#{arf}".should == "inprocess"
    end
  end


  describe "complete" do

    it "sets the complete params" do
      arf = AdminRequestFilter.new('available')
      arf.inprocess?.should be_false
      arf.complete?.should be_true

      arf.inprocess_css_class.should == ""

      "#{arf}".should == "available"
    end
  end



  describe "invalid filter" do


    it " raises an error if an ivalid filter is passed in " do
      lambda {
        AdminRequestFilter.new('asdfadsfafds')
      }.should raise_error
    end
  end


end
