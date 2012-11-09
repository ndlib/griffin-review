require 'spec_helper'

describe "admin/open_item/show" do
  before(:each) do
    @item = assign(:open_item, stub_model(OpenItem))
  end

  it "renders attributes in <p>" do
    render
  end
end
