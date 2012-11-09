require 'spec_helper'

describe "OpenItem" do

  before(:all) do
    @admin_role = Factory.create(:admin_role)
    @admin_user = Factory.create(:user)
    @admin_user.roles = [@admin_role]
    @open_item = Factory.create(:open_item, :edition => 'Best One', :publisher => 'Publisher 1', :display_note => 'Mock display note')
  end

  after(:all) do
    @admin_user.destroy
    @admin_role.destroy
    @open_item.destroy
  end

  describe "Create new open_item" do
    it "fills in the new open_item form and submits" do
      login_as @admin_user
      expect {
        visit new_admin_open_item_path
        fill_in 'Title', :with => @open_item.title
        fill_in 'Edition', :with => @open_item.edition
        fill_in 'Publisher', :with => @open_item.publisher
        fill_in 'Display note', :with => @open_item.display_note
        click_button 'Create Open Item'
      }.to change(OpenItem, :count).by(1)
    end
  end
end
