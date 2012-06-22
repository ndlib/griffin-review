require 'spec_helper'

describe "admin/item/edit" do
  before(:each) do
    @item = assign(:item, stub_model(Item))
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_item_path(@item), :method => "post" do
    end
  end
end
