require 'spec_helper'

describe "admin/item/new" do
  before(:each) do
    assign(:item, stub_model(Item).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_item_index_path, :method => "post" do
    end
  end
end
