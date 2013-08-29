require 'spec_helper'

describe DiscoveryApi do
  let(:test_search) { "ndu_aleph000188916" }

  describe :search_by_ids do

    it "searchs by a single id" do

      VCR.use_cassette 'discovery/search_single_id_response' do
        res = DiscoveryApi.search_by_ids(test_search)
        res.size.should == 1
        res.first.title.should == "The once and future king."
      end

    end

    it "searchs by multiple ids"

  end


  describe "attributes" do

    before(:each) do
      VCR.use_cassette 'discovery/attributes_single_id_response' do
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
      @discovery_api.details.should == ""
    end



    it "has publisher_provider" do
      @discovery_api.publisher_provider.should == "New York, Putnam 1958"
    end


    it "has availability" do
      @discovery_api.availability.should == "Available"
    end


    it "has availabile_library" do
      @discovery_api.available_library.should == "Notre Dame, Hesburgh Library General Collection (PR 6045 .H676 O5 )"
    end

  end


  describe :truncation do
    before(:each) do
      VCR.use_cassette 'discovery/truncation_single_id_response' do
        @discovery_api = DiscoveryApi.search_by_ids(test_search).first
      end
    end

    it "truncates the publisher_provider" do
      String.any_instance.should_receive(:truncate)
      @discovery_api.publisher_provider
    end


    it "truncates the creator_contributor" do
      String.any_instance.should_receive(:truncate)
      @discovery_api.creator_contributor
    end


    it "truncates the details" do
      String.any_instance.should_receive(:truncate)
      @discovery_api.details
    end
  end
end
