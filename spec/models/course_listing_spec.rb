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


    it "has student_comments" do
      course_listing.respond_to?(:student_comments).should be_true
    end

    it "has a citation" do
      course_listing.respond_to?(:citation).should be_true
    end


    it "has a css class for the record display" do
      course_listing.respond_to?(:css_class)
    end


    describe :tags do

      it "has tags" do
        course_listing.respond_to?(:tags).should be_true
      end
    end
  end
end
