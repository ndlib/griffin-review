require 'spec_helper'

describe ItemType do

  before(:all) do
    @itemtype1 = Factory.build(:item_type)
    @itemtype2 = Factory.build(:item_type)
  end

  it do
    @itemtype1.should be_valid
  end

  it "should have both a name and a description" do
    @itemtype1.name.should_not be_blank
    @itemtype1.description.should_not be_blank
  end

  it "should not validate if name or description are blank" do
    @bad_item_type = Factory.build(:item_type, :name => '', :description => '')
    @bad_item_type.should have_at_least(1).error_on(:name)
    @bad_item_type.should have_at_least(1).error_on(:description)
  end
end
