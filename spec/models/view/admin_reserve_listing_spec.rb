

describe AdminReserveListing do


  it "has a title" do
    AdminReserveListing.new(Reserve.new).respond_to?(:title)
  end

  it "has an id" do
    AdminReserveListing.new(Reserve.new).respond_to?(:id)
  end

  it "has the date needed" do
    AdminReserveListing.new(Reserve.new).respond_to?(:needed_by)
  end


  it "has a request date " do
    AdminReserveListing.new(Reserve.new).respond_to?(:request_date)
  end

  it "has a type" do
    AdminReserveListing.new(Reserve.new).respond_to?(:type)
  end


  it "has the workflow state" do
    AdminReserveListing.new(Reserve.new).respond_to?(:workflow_state)
  end


  it "has a requestor" do
    AdminReserveListing.new(Reserve.new).respond_to?(:requestor)
  end



end
