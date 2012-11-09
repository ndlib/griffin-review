require 'spec_helper'

describe "admin/open_item/new" do
  before(:each) do
    assign(:open_item, stub_model(OpenItem).as_new_record)
  end

  it "renders new open item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_open_item_index_path, :method => "post" do
    end
  end
end
