
require 'spec_helper'

describe AdminEditReserves do

  let(:admin_reserve_app) { ReservesAdminApp.new("semester", "current_user") }

  before(:each) do
    @reserve = admin_reserve_app.reserve(2)
  end

  describe "set_meta_data" do

    it "removes the nd meta data id when meta data is set " do
      @reserve.set_nd_meta_data_id("did")

      @reserve.set_meta_data(title: "new")

      @reserve.reserve.nd_meta_data_id.should be_nil
    end


    it "sets the title" do
      @reserve.set_meta_data(title: "new")

      @reserve.reserve.title.should == "new"
    end


    it "sets a creator" do
      @reserve.set_meta_data(creator: "new")

      @reserve.reserve.creator.should == "new"
    end


    it "sets a publisher" do
      @reserve.set_meta_data(publisher: "new")

      @reserve.reserve.publisher.should == "new"
    end

  end


  describe "set_nd_meta_data_id" do

    it "sets the discovery id "

    it "sets the url if there is no url and id has an electronic version"

  end
end
