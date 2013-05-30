require 'spec_helper'

describe Item do

  describe "validations" do

    it " requires a title" do
      Item.new.should have(1).error_on(:title)
    end

    it "requires a type" do
      Item.new.should have(1).error_on(:type)
    end

  end



  it "uses the api search service to find items with an nd_meta_data_id" do
    stub_discovery!

    i = Item.new(:title => 'the title', :nd_meta_data_id => 'metadata')
    i.title.should == "Book."
  end


  it "uses the meta data in the record if the there is not nd_meta_data_id" do
    i = Item.new(:title => 'the title')

    i.title.should == "the title"
  end


  it "uses the meta data in the item record if overwrite_nd_meta_data is true" do
    i = Item.new(:title => 'the title', :nd_meta_data_id => 'metadata', :overwrite_nd_meta_data => true)

    i.title.should == "the title"
  end
end
