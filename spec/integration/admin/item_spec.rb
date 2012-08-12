require 'spec_helper'
# require 'casclient/frameworks/rails/filter'

describe "Item" do

  before(:all) do
    @admin_role = Factory.create(:admin_role)
    @admin_user = Factory.create(:user)
    @admin_user.roles = [@admin_role]
    @item = Factory.create(:item, :edition => 'Best One', :publisher => 'Publisher 1', :display_note => 'Mock display note')
  end

  after(:all) do
    @admin_user.destroy
    @admin_role.destroy
    @item.destroy
  end

  describe "Create new item" do
    it "fills in the new item form and submits" do
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
