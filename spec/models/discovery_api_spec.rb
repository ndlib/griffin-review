require 'spec_helper'

describe DiscoveryApi do
  let(:test_search) { "the once and future king" }

  describe :search_by_ids do

    it "searchs by a single id" do

      VCR.use_cassette 'discovery/single_id_response' do
        res = DiscoveryApi.search_by_ids(test_search)
        res.size.should == 1
        res.first.title.should == "The once and future king."
      end

    end

    it "searchs by multiple ids"

  end


  describe "attributes" do

    before(:each) do
      VCR.use_cassette 'discovery/single_id_response' do
        @discovery_api = DiscoveryApi.search_by_ids(test_search).first
      end
    end

    it "has a title" do
      @discovery_api.title.should == "The once and future king."
    end


    it "has the creator_contributor" do
      @discovery_api.creator_contributor.should == "T. H. White [Terence Hanbury], 1906-1964."
    end


    it "has details" do
      @discovery_api.details.should == nil
    end



    it "has publisher_provider" do
      @discovery_api.publisher_provider.should == "London, Collins 1958"
    end


    it "has availability" do
      @discovery_api.availability.should == "Available"
    end


    it "has availabile_library" do
      @discovery_api.available_library.should == "Notre Dame, Hesburgh Library Special Coll.&nbsp;Rare Books Medium (PR 6045 .H2 O523 1958 )"
    end

  end
end
