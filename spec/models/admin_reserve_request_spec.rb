require 'spec_helper'

describe AdminReserveRequest do


  let(:current_user) { "USER" }


  describe :attributes do

    it "has the reserve attributes" do
      reserve = Reserve.new()
      admin_reserve = AdminReserveRequest.new(reserve, current_user)

      atts = [:title, :journal_title, :length, :file, :url, :course, :id, :note, :citation, :comments, :article_details, :requestor_owns_a_copy, :number_of_copies, :creator, :needed_by, :requestor_has_an_electronic_copy, :length, :discovery_id, :library, :publisher]

      atts.each do | attr |
        admin_reserve.respond_to?(attr).should be_true
      end
    end
  end


  describe "#has_nd_record_id?" do

    it "returns true if the request has been connected to the nd discovery systems " do
      reserve = Reserve.new(:discovery_id => 'id')

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.has_nd_record_id?.should be_true
    end

    it "returns false if the request has not been connected to the nd discovery systems " do
      reserve = Reserve.new(:discovery_id => nil)

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.has_nd_record_id?.should be_false
    end
  end


  describe "#has_internal_metadata?" do

    it "returns true if the metadata has been typed in for the record"

    it "returns false if the metadata has not been typed in" do
      reserve = Reserve.new()

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.has_internal_metadata?.should be_false
    end
  end


  describe "#needs_external_source?" do

    it "returns true if the item needs a file" do
      reserve = Reserve.new()

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.stub!('can_have_uploaded_file?').and_return(true)

      admin_reserve.needs_external_source?.should be_true
    end


    it "returns false if the item already has a file" do
      reserve = Reserve.new(:file => 'file')

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.stub!(:can_have_uploaded_file?).and_return(true)

      admin_reserve.needs_external_source?.should be_false
    end


    it "returns true if the item needs a url" do
      reserve = Reserve.new()

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.stub!(:can_have_url?).and_return(true)
      puts admin_reserve.can_have_url?

      admin_reserve.needs_external_source?.should be_true
    end


    it "returns false if the item already has a url" do
      reserve = Reserve.new(:url => 'url')

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.stub!(:can_have_url?).and_return(true)
      puts admin_reserve.can_have_url?

      admin_reserve.needs_external_source?.should be_false
    end

  end


  describe "#can_have_uploaded_file?" do

    it "returns true if the type of the request is a book chapter" do
      reserve = BookChapterReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_uploaded_file?.should be_true
    end


    it "returns true if the type of the request is an article " do
      reserve = JournalReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_uploaded_file?.should be_true
    end


    it "returns false if the type is a book" do
      reserve = BookReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_uploaded_file?.should be_false
    end


    it "returns false if the type is a video" do
      reserve = VideoReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_uploaded_file?.should be_false

    end

    it "returns false if the tyoe is an article" do
      reserve = AudioReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_uploaded_file?.should be_false

    end
  end


  describe "#can_have_url?" do

    it "returns false if the type of the request is a book chapter" do
      reserve = BookChapterReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_url?.should be_false
    end


    it "returns true if the type of the request is an article " do
      reserve = JournalReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_url?.should be_true
    end


    it "returns false if the type is a book" do
      reserve = BookReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_url?.should be_false
    end


    it "returns true if the type is a video" do
      reserve = VideoReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_url?.should be_true

    end

    it "returns true if the tyoe is an article" do
      reserve = AudioReserve.new

      admin_reserve = AdminReserveRequest.new(reserve, current_user)
      admin_reserve.can_have_url?.should be_true

    end
  end

end
