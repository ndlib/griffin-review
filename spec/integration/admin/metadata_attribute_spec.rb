require 'spec_helper'

describe "Metadata Attribute Integration" do
  before(:all) do
    @media_admin_role = Factory.create(:media_admin_role)
    @media_admin_user = Factory.create(:user)
    @media_admin_user.roles = [@media_admin_role]
    @jane_user = Factory.create(:user)
    @metadata_a = Factory.create(:metadata_attribute)
    @metadata_b = Factory.create(:metadata_attribute)
  end
  describe "Change metadata attribute parameters via edit screen" do
    before :all do
      Capybara.default_wait_time = 5 
      Capybara.current_driver = :selenium
    end
    before :each do
     login_as @media_admin_user 
    end
    after :each do
      logout @media_admin_user
    end
    it "displays the correct metadata record info on edit screen" do
      visit metadata_attribute_edit_path(@metadata_a)
      find_field('Name').value.should eq(@metadata_a.name)
      find_field('Definition').value.should include(@metadata_a.definition)
      find_button('Save').value.should eq('Save')
    end
    it "changes the name" do
      visit metadata_attribute_edit_path(@metadata_a)
      find_field('Name').value.should eq(@metadata_a.name)
      fill_in 'Name', :with => 'Alternate Name'
      click_button('Save')
      visit metadata_attribute_edit_path(@metadata_a)
      find_field('Name').value.should eq('Alternate Name')
    end
    it "deletes a metadata record" do
      visit metadata_attribute_edit_path(@metadata_a)
      expect {
        click_link('Delete')
      }.to change(MetadataAttribute, :count).from(2).to(1)
      current_path.should eq(all_metadata_attribute_path)
    end
  end
end
