require 'spec_helper'
require 'casclient/frameworks/rails/filter'

describe "Item" do
  describe "GET /admin/item/new" do
    it "fills in the new item form and submits" do
      @admin_role = Factory.create(:admin_role)
      @admin_user = Factory.create(:user, :roles => [@admin_role])
      @item = Factory.create(:item, :edition => 'Best One', :publisher => 'Publisher 1', :display_note => 'Mock display note')
      login_as @admin_user
      expect {
        visit new_admin_item_path
        fill_in 'Title', :with => @item.title
        fill_in 'Edition', :with => @item.edition
        fill_in 'Publisher', :with => @item.publisher
        fill_in 'Display note', :with => @item.display_note
        click_button 'Create Item'
      }.to change(Item, :count).by(1)
    end
  end
end
