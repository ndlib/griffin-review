

describe AdminReserveRow do


  it "has a title" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:title)).to be_true
  end

  it "has an id" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:id)).to be_true
  end

  it "has the date needed" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:needed_by)).to be_true
  end


  it "catches if the needed_by date is nil" do |variable|
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).needed_by).to eq("Not Entered")
  end


  it "has a request date " do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:request_date)).to be_true
  end


  it "has a type" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:type)).to be_true
  end


  it "has the workflow state" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:workflow_state)).to be_true
  end


  it "has a requestor column" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:requestor_col)).to be_true
  end


  it "has a column for course" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:course_col)).to be_true
  end


  it "has a cache key" do
    expect(AdminReserveRow.new(Reserve.new, ApplicationController.new).respond_to?(:cache_key)).to be_true
  end


  it "makes the key out of the reserve" do
    reserve = mock_reserve FactoryGirl.create(:request), nil
    expect(AdminReserveRow.new(reserve, ApplicationController.new).cache_key).to eq("admin-reserve-#{reserve.id}-#{reserve.updated_at.to_s.gsub(' ', '-').gsub('/', '-')}")
  end

end
