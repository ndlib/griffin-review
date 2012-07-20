require 'spec_helper'

describe "Items" do
  describe "GET /items" do
    it "gets the index page" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admin_item_index_path
      response.status.should be(302)
    end
  end
end
