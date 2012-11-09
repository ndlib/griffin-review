require 'spec_helper'

describe "admin/open_item/index" do
  before(:each) do
    assign(:open_items, [
      stub_model(OpenItem),
      stub_model(OpenItem)
    ])
  end

  it "renders a list of open_items" do
    render
  end
end
