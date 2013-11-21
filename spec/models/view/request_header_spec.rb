

describe RequestHeader do


  before(:each) do
    @reserve = double(Reserve, id: 1, title: "title", type: "BookReserve", course: double(Course, title: 'course_title', id: 1, crosslisted_course_ids: ['id1', 'id2'], section_numbers: ['1', '2']))
    @request_header = RequestHeader.new(@reserve)
  end


  it "has a title" do
    expect(@request_header.title).to eq("title")
  end


  it "traps special characters in the title" do
    ERB::Util.should_receive(:h)
    @request_header.title
  end


  it "has a type with out the word reserve" do
    expect(@request_header.type).to eq("Book")
  end


  it "traps special characters in the type" do
    ERB::Util.should_receive(:h)
    @request_header.type
  end


  it "generates a link to the course" do
    expect(@request_header.course_link).to eq("<a href=\"/courses/1/reserves\">course_title</a>")
  end


  it "creates crosslistings and section infor" do
    expect(@request_header.crosslist_and_sections).to eq("id1, id2 - 1, 2")
  end
end
