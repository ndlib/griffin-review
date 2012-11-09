require 'spec_helper'

describe TechnicalMetadata do

  before(:all) do
    @metadata1 = Factory.build(:metadata_attribute, :metadata_type => 'technical')
    @metadata2 = Factory.build(:metadata_attribute, :metadata_type => 'technical')
    @tech_meta1 = Factory.build(:technical_metadata, :metadata_attribute => @metadata1)
  end

  it "should be a valid technical metadata object" do
    @tech_meta1.value.should_not be_blank
    @tech_meta1.metadata_attribute.should eq @metadata1
  end
  it "should be associated with a technical metadata attribute" do
    @tech_meta1.metadata_attribute.metadata_type.should eq 'technical'
  end
  it "should be able to change value" do
    @tech_meta1.value = "Another value"
    @tech_meta1.save
    @tech_meta_alt = TechnicalMetadata.find(@tech_meta1.id)
    @tech_meta_alt.value.should eq 'Another value'
  end
end
