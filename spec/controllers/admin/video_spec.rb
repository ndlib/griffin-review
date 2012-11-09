require 'spec_helper'

describe Admin::VideoController do

  before(:all) do
    @metadata1 = Factory.create(:metadata_attribute)
    @metadata2 = Factory.create(:metadata_attribute, :metadata_type => 'basic')
    @metadata3 = Factory.create(:metadata_attribute, :metadata_type => 'technical')
    @generic_item_type = Factory.create(:item_type)
    @video_item_type = Factory.create(:item_type, :name => 'Video')
    @generic_item = Factory.create(:item, :item_type => @generic_item_type)
    @video_item1 = Factory.create(:video, :item_type => @video_item_type)
    @video_item2 = Factory.create(:video, :item_type => @video_item_type)
    @video_item3 = Factory.create(:video, :item_type => @video_item_type)
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

  context "View, edit and delete video items" do
    describe "with media admin account" do
      before(:each) do
        sign_in @media_admin_user
      end
      after(:each) do
        sign_out @media_admin_user
      end
      it "is able to view the video item list" do
        get :index
        assigns(:videos).should include(@video_item1, @video_item2)
        assigns(:videos).should_not include(@generic_item)
      end
      it "is able to stage a new video item records" do
        get :new
        assigns(:video).should be_instance_of(Video)
        assigns(:video_type).should be_instance_of(ItemType)
        assigns(:video_type).name.should eql('Video')
      end
      it "is able to open a video item record" do
        get :show, :id => @video_item2.id
        assigns(:video).should be_instance_of(Video)
        assigns(:video).name.should eql(@video_item2.name)
        assigns(:video).description.should eql(@video_item2.description)
      end
      it "saves the video record to the database" do
        expect {
          post :create, :video => Factory.attributes_for(:video, :item_type_id => @video_item_type.id)
        }.to change(Video, :count).by(1)
      end
      it "adds a basic attribute to a video record" do
          post :update, :id => @video_item1.id, :video => {
            :name => @video_item1.name, 
            :basic_metadata_attributes => Factory.build(:basic_metadata, :value => 'Initial value', :item_id => @video_item1.id).attributes
          }
          @video_item1.basic_metadata[0].value.should eq("Initial value")
      end
      it "adds a technical attribute to a video record" do
          post :update, :id => @video_item1.id, :video => {
            :name => @video_item1.name, 
            :technical_metadata_attributes => Factory.build(:technical_metadata, :value => 'Initial value', :item_id => @video_item1.id).attributes
          }
          @video_item1.technical_metadata[0].value.should eq("Initial value")
      end
      it "adds multiple basic attributes to a video record" do
        post :update, :id => @video_item1.id, :video => {
          :name => @video_item1.name, 
          :basic_metadata_attributes => [
            Factory.build(:basic_metadata, :value => 'Initial value', :item_id => @video_item1.id).attributes, 
            Factory.build(:basic_metadata, :value => 'Another initial value', :item_id => @video_item1.id).attributes
          ]
        }
        @video_item1.basic_metadata.count.should == 2
      end
      it "updates existing basic attribute for video record" do
        @basic_metadata = Factory.create(:basic_metadata, :item_id => @video_item1.id, :value => "Initial attribute value")
        @basic_metadata.value = "Another new value"
        post :update, :id => @video_item1.id, :video => {:basic_metadata_attributes => @basic_metadata.attributes}
        @video_item1.reload
        @video_item1.basic_metadata[0].value.should eq("Another new value")
      end
      it "deletes a basic attribute for a video record" do
        @basic_metadata1 = Factory.create(:basic_metadata, :item_id => @video_item1.id, :value => "First attribute value")
        @basic_metadata2 = Factory.create(:basic_metadata, :item_id => @video_item1.id, :value => "Second attribute value")
        delete :destroy_attribute, :id => @video_item1.id, :metadata_id => @basic_metadata2.id, :metadata_type => 'basic', :video_id => @video_item1.id
        @video_item1.basic_metadata.count.should == 1
      end
      it "does not save an invalid record" do
        expect {
          post :create, :video => Factory.attributes_for(:video, :name => '')
        }.to_not change(Video, :count)
      end
      it "should send user back to new video page for invalid record" do
        post :create, :video => Factory.attributes_for(:video, :name => '')
        response.should render_template 'admin/video/new'
      end
      it "instantiates the correct video record for edit function" do
        get :edit, {:id => @video_item1.id}
        assigns(:video).should eql(@video_item1)
      end
      it "should open the edit page for a video" do
        get :edit, {:id => @video_item2.id}
        response.should render_template :edit
      end
      it "should update a record with valid data" do
        put :update, :id => @video_item2.id,
          :video => Factory.attributes_for(
            :video,
            :name => 'Another Name',
            :description => 'Another description',
            :item_type_id => @video_item_type.id
          )
          @video_item2.reload
          @video_item2.description.should eq('Another description')
      end
      it "deletes video record" do
        expect {
          delete :destroy, {:id => @video_item3.id}
        }.to change(Video, :count).by(-1)
      end
    end
    describe "with no special privileges" do
      before(:each) do
        sign_in @jane_user
      end
      after(:each) do
        sign_out @jane_user
      end
      it "is not able to view the video item list" do
        get :index
        response.should_not render_template :index
        response.should redirect_to :admin_not_authorized
      end
      it "is not able to open a video item for editing" do
        get :show, :id => @video_item2.id
        response.should redirect_to :admin_not_authorized
      end
      it "is not able to post an update to a video item" do
        put :update, :id => @video_item2.id,
          :video => Factory.attributes_for(
            :video,
            :name => 'Another Name',
            :description => 'Another description',
            :item_type_id => @video_item_type.id
          )
        response.should redirect_to :admin_not_authorized
      end
      it "is not able to delete a video record" do
        expect {
          delete :destroy, {:id => @video_item3.id}
        }.to change(Video, :count).by(0)
      end
    end
  end
end
