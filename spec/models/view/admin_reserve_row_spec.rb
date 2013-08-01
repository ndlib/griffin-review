

describe AdminReserveRow do


  it "has a title" do
    AdminReserveRow.new(Reserve.new).respond_to?(:title)
  end

  it "has an id" do
    AdminReserveRow.new(Reserve.new).respond_to?(:id)
  end

  it "has the date needed" do
    AdminReserveRow.new(Reserve.new).respond_to?(:needed_by)
  end


  it "catches if the needed_by date is nil" do |variable|
    AdminReserveRow.new(Reserve.new).needed_by.should == "Not Entered"
  end


  it "has a request date " do
    AdminReserveRow.new(Reserve.new).respond_to?(:request_date)
  end

  it "has a type" do
    AdminReserveRow.new(Reserve.new).respond_to?(:type)
  end


  it "has the workflow state" do
    AdminReserveRow.new(Reserve.new).respond_to?(:workflow_state)
  end


  it "has a requestor" do
    AdminReserveRow.new(Reserve.new).respond_to?(:requestor)
  end

end