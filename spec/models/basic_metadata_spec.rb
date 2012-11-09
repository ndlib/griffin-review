require 'spec_helper'

describe BasicMetadata do

  before(:all) do
    @metadata1 = Factory.build(:metadata_attribute, :metadata_type => 'basic')
    @metadata2 = Factory.build(:metadata_attribute, :metadata_type => 'technical')
    @basic_meta1 = Factory.build(:basic_metadata, :metadata_attribute => @metadata1)
  end

  it "should be a valid basic metadata object" do
    @basic_meta1.value.should_not be_blank
  end
  it "should be associated with a basic metadata attribute" do
    @basic_meta1.metadata_attribute.metadata_type.should eq 'basic'
  end
  it "should be able to change value" do
    @basic_meta1.value = "Another value"
    @basic_meta1.save
    @basic_meta_alt = BasicMetadata.find(@basic_meta1.id)
    @basic_meta_alt.value.should eq 'Another value'
  end
end
