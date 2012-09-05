require 'spec_helper'

describe MetadataAttribute do

  before(:all) do
    @metadata1 = Factory.build(:metadata_attribute)
    @metadata2 = Factory.build(:metadata_attribute)
  end

  it do
    @metadata1.should be_valid
  end

  it "should have both a name and a definition" do
    @metadata1.name.should_not be_blank
    @metadata1.definition.should_not be_blank
  end

  it "should not validate if name or definition are blank" do
    @bad_metadata_attribute = Factory.build(:metadata_attribute, :name => '', :definition => '')
    @bad_metadata_attribute.should have_at_least(1).error_on(:name)
    @bad_metadata_attribute.should have_at_least(1).error_on(:definition)
  end
end
