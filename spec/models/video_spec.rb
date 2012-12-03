require 'spec_helper'

describe Video do

  before(:all) do
    @metadata1 = Factory.build(:metadata_attribute)
    @metadata2 = Factory.build(:metadata_attribute, :metadata_type => 'basic')
    @metadata3 = Factory.build(:metadata_attribute, :metadata_type => 'technical')
    @item_type1 = Factory.build(:item_type)
    @item_type2 = Factory.build(:item_type)
    @video1 = Factory.build(:video, :item_type => @item_type1)
    @video2 = Factory.build(:video, :item_type => @item_type1)
  end

  it "should be a valid video record" do
    @video1.should be_valid
  end

  it "should have a name, description and item type" do
    @video1.name.should_not be_blank
    @video1.description.should_not be_blank
    @video1.item_type.should be_instance_of(ItemType)
  end

  it "should not validate if any of name, description, and item type are blank" do
    @video_bad = Factory.build(:video, :name => '', :description => '', :item_type => nil)
    @video_bad.should have_at_least(1).error_on(:name)
    @video_bad.should have_at_least(1).error_on(:description)
    @video_bad.should have_at_least(1).error_on(:item_type)
  end

  it "should be associated with properly assigned metadata attributes" do
    @basic_meta = BasicMetadata.new
    @basic_meta.metadata_attribute = @metadata2
    @basic_meta.item = @video1
    @basic_meta.value = "Test Value"
    @basic_meta.save
    @tech_meta = TechnicalMetadata.new
    @tech_meta.metadata_attribute = @metadata3
    @tech_meta.item = @video1
    @tech_meta.value = '125 minutes'
    @tech_meta.save
    @video1.basic_metadata.should include(@basic_meta)
  end

end
