require 'spec_helper'

describe "external/request/new", :type => :request do
  before(:each) do
    @r = assign(:request, stub_model(Request))
  end

  it "renders the new request form" do

    render

     assert_select "form", :action => "#{video_request_path}", :method => 'post' do
       assert_select 'input#r_needed_by[name=?]', 'request[needed_by]'
       assert_select 'select#r_semester[name=?]', "request[semester_id]"
       assert_select 'input#r_title[name=?]', "request[title]"
       assert_select 'input#r_course[name=?]', "request[course]"
     end
  end
end
