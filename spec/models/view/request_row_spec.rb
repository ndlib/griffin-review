

describe RequestRow do

  it "has a title" do
    expect(RequestRow.new(Reserve.new).respond_to?(:title)).to be_true
  end

  it "links to the title" do
    row = RequestRow.new(Reserve.new(id: 1, title: 'title'))
    expect(row.title).to eq("<a href=\"/admin/requests/1\" target=\"_blank\">title</a>")
  end


  it "shows the selection title when there is a selection title" do
    row = RequestRow.new(Reserve.new(id: 1, title: 'title', selection_title: 'selection_title'))
    expect(row.title).to eq("<a href=\"/admin/requests/1\" target=\"_blank\">selection_title</a><br>title")
  end


  it "has an id" do
    expect(RequestRow.new(Reserve.new).respond_to?(:id)).to be_true
  end

  it "has the date needed" do
    expect(RequestRow.new(Reserve.new).respond_to?(:needed_by)).to be_true
  end


  it "catches if the needed_by date is nil" do |variable|
    expect(RequestRow.new(Reserve.new).needed_by).to eq("Not Entered")
  end


  it "needed_by_json catches if needed_by is nil" do
    expect(RequestRow.new(Reserve.new).needed_by_json).to eq(9999999999)
  end


  it "has a request date " do
    expect(RequestRow.new(Reserve.new).respond_to?(:request_date)).to be_true
  end


  it "has a type" do
    expect(RequestRow.new(Reserve.new).respond_to?(:type)).to be_true
  end


  it "has the workflow state" do
    expect(RequestRow.new(Reserve.new).respond_to?(:workflow_state)).to be_true
  end


  it "has a requestor column" do
    expect(RequestRow.new(Reserve.new).respond_to?(:requestor_col)).to be_true
  end


  it "has a instructor_col" do
    expect(RequestRow.new(Reserve.new).respond_to?(:instructor_col)).to be_true
  end

  it "has a column for course" do
    expect(RequestRow.new(Reserve.new).respond_to?(:course_col)).to be_true
  end


  it "has a cache key" do
    expect(RequestRow.new(Reserve.new).respond_to?(:cache_key)).to be_true
  end


  it "makes the key out of the reserve" do
    reserve = mock_reserve FactoryGirl.create(:request), nil
    expect(RequestRow.new(reserve).cache_key).to eq("admin-reserve-#{reserve.id}-#{reserve.updated_at.to_s.gsub(' ', '-').gsub('/', '-')}#{reserve.item.updated_at.to_s.gsub(' ', '-').gsub('/', '-')}")
  end


  it "makes an array for json rendering" do
    Reserve.any_instance.stub(:course).and_return(double(Course, id: 'course_id', semester: FactoryGirl.create(:semester), full_title: 'Course', primary_instructor: double(User, first_name: 'fname', last_name: 'lname', username: 'username')))
    r = Reserve.new(title: 'json', needed_by: '1/1/2013', requestor_netid: 'jhartzle', course_id: 'course_id', type: 'VideoReserve', physical_reserve: true, electronic_reserve: false)
    r.save!

    expect(RequestRow.new(r).to_json).to eq([" 1 Jan", "<a href=\"/admin/requests/2\" target=\"_blank\">json</a>", " 7 Aug", "<a href=\"/masquerades/new?username=username\">lname, fname</a>", "<a href=\"/courses/course_id/reserves\" target=\"_blank\">Course</a>", "Video", r.created_at.to_time.to_i, 1357016400, " physical"])
  end


end
