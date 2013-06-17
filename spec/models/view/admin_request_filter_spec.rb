

describe AdminRequestFilter do


  describe "new" do

    it "sets the new params" do
      arf = AdminRequestFilter.new('new')
      arf.new?.should be_true
      arf.awaiting?.should be_false
      arf.complete?.should be_false
      arf.all?.should be_false

      arf.new_css_class.should == "active"
      arf.awaiting_css_class.should == ""
      arf.complete_css_class.should == ""
      arf.all_css_class.should == ""

      "#{arf}".should == "new"
    end

  end


  describe "awaiting" do

    it "sets the awaiting params" do
      arf = AdminRequestFilter.new('awaiting')
      arf.new?.should be_false
      arf.awaiting?.should be_true
      arf.complete?.should be_false
      arf.all?.should be_false

      arf.new_css_class.should == ""
      arf.awaiting_css_class.should == "active"
      arf.complete_css_class.should == ""
      arf.all_css_class.should == ""

      "#{arf}".should == "awaiting"
    end
  end


  describe "complete" do

    it "sets the complete params" do
      arf = AdminRequestFilter.new('complete')
      arf.new?.should be_false
      arf.awaiting?.should be_false
      arf.complete?.should be_true
      arf.all?.should be_false

      arf.new_css_class.should == ""
      arf.awaiting_css_class.should == ""
      arf.complete_css_class.should == "active"
      arf.all_css_class.should == ""

      "#{arf}".should == "complete"
    end
  end

  describe "all" do

    it "sets the all params" do
      arf = AdminRequestFilter.new('all')
      arf.new?.should be_false
      arf.awaiting?.should be_false
      arf.complete?.should be_false
      arf.all?.should be_true

      arf.new_css_class.should == ""
      arf.awaiting_css_class.should == ""
      arf.complete_css_class.should == ""
      arf.all_css_class.should == "active"

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


end
