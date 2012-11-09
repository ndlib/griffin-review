require 'spec_helper'

describe Admin::ItemController do

  before(:all) do
    @metadata1 = Factory.build(:metadata_attribute)
    @metadata2 = Factory.build(:metadata_attribute, :metadata_type => 'basic')
    @metadata3 = Factory.build(:metadata_attribute, :metadata_type => 'technical')
    @item_type1 = Factory.build(:item_type)
    @item_type2 = Factory.build(:item_type)
    @item1 = Factory.build(:item, :item_type => @item_type1)
    @item2 = Factory.build(:item, :item_type => @item_type1)
    @reserves_admin_role = Factory.create(:reserves_admin_role)
    @reserves_admin_user = Factory.create(:user)
    @reserves_admin_user.roles = [@reserves_admin_role]
    @media_admin_role = Factory.create(:media_admin_role)
    @media_admin_user = Factory.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    @jane_user = Factory.create(:user)
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context "View all items" do
    describe "with reserves admin account" do
      it "is able to view the item list" do
        
      end
      it "is able to open a item record" do
        
      end
    end
    describe "with no special privileges" do
      it "is not able to view the item list"
      it "is not able to open a item for editing"
    end
  end
end
