require 'spec_helper'

describe CourseListing do

  let(:course_listing) { CourseListing.new()}

  describe "attribute fields" do

    it "has a title" do
      course_listing.respond_to?(:title).should be_true
    end


    it "has a creator" do
      course_listing.respond_to?(:creator).should be_true
    end


    it "has a journal title" do
      course_listing.respond_to?(:journal_title).should be_true
    end


    it "has a length" do
      course_listing.respond_to?(:length).should be_true
    end


    it "has a file" do
      course_listing.respond_to?(:file).should be_true
    end


    it "has a url" do
      course_listing.respond_to?(:url).should be_true
    end
  end
end
