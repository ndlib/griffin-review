require 'spec_helper'

describe "admin/open_item/edit" do
  before(:each) do
    @open_item = assign(:open_item, stub_model(OpenItem))
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_open_item_path(@open_item), :method => "post" do
    end
  end
end
