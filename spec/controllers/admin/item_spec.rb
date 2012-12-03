require 'spec_helper'

describe Admin::ItemController do

  before(:all) do
    @metadata1 = Factory.create(:metadata_attribute)
    @metadata2 = Factory.create(:metadata_attribute, :metadata_type => 'basic')
    @metadata3 = Factory.create(:metadata_attribute, :metadata_type => 'technical')
    @item_type1 = Factory.create(:item_type)
    @item_type2 = Factory.create(:item_type)
    @item1 = Factory.create(:item, :item_type => @item_type1)
    @item2 = Factory.create(:item, :item_type => @item_type1)
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
      before(:each) do
        sign_in @reserves_admin_user
      end
      after(:each) do
        sign_out @reserves_admin_user
      end
      it "is able to view the item list" do
        get :full_list
        assigns(:items).should include(@item1, @item2)
      end
      it "is able to open a item record" do
        get :show, :id => @item2.id
        assigns(:item).should be_instance_of(Item)
        assigns(:item).name.should eql(@item2.name)
        assigns(:item).description.should eql(@item2.description)
      end
    end
    describe "with no special privileges" do
      before(:each) do
        sign_in @jane_user
      end
      after(:each) do
        sign_out @jane_user
      end
      it "is not able to view the item list" do
        get :full_list
        response.should_not render_template :index
        response.should redirect_to :admin_not_authorized
      end
      it "is not able to open a item for editing" do
        get :edit, :id => @item2.id
        response.should redirect_to :admin_not_authorized
      end
    end
  end
end
