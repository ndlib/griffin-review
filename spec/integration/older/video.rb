require 'spec_helper'

describe "Video Integration" do
  
  before(:all) do
    @metadata1 = FactoryBot.create(:metadata_attribute)
    @metadata2 = FactoryBot.create(:metadata_attribute, :metadata_type => 'basic')
    @metadata3 = FactoryBot.create(:metadata_attribute, :metadata_type => 'technical')
    @generic_item_type = FactoryBot.create(:item_type)
    @video_item_type = FactoryBot.create(:item_type, :name => 'Video')
    @generic_item = FactoryBot.create(:item, :item_type => @generic_item_type)
    @video_item1 = FactoryBot.build(:video, :item_type => @video_item_type)
    @video_item2 = FactoryBot.build(:video, :item_type => @video_item_type)
    @video_item3 = FactoryBot.build(:video, :item_type => @video_item_type)
    @reserves_admin_role = FactoryBot.create(:reserves_admin_role)
    @reserves_admin_user = FactoryBot.create(:user)
    @reserves_admin_user.roles = [@reserves_admin_role]
    @media_admin_role = FactoryBot.create(:media_admin_role)
    @media_admin_user = FactoryBot.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    @jane_user = FactoryBot.create(:user)
  end

  describe "Adding, updating and deleting a video record" do
    before :each do
     login_as @media_admin_user 
    end
    after :each do
      logout @media_admin_user
    end
    
    it "displays the screen to add a new video record" do
      visit new_admin_video_path
      fill_in 'Name', :with => @video_item1.name
      fill_in 'Description', :with => @video_item1.description
      click_button('Save')
      @video_item_latest = Video.last
      visit edit_admin_video_path(@video_item_latest)
      find_field('Name').value.should eq(@video_item1.name)
    end
    
  end
  
end