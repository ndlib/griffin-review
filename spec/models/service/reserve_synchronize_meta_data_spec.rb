require 'spec_helper'


describe ReserveSynchronizeMetaData do

  describe :check_synchronized! do

    context "reserve can be synchronized " do

      before(:each) do
        course = double(Course, id: "id", crosslist_id: "crosslist_id", semester: FactoryGirl.create(:semester))
        CourseSearch.any_instance.stub(:get).and_return(course)

        @reserve = Reserve.new(nd_meta_data_id: "ndid", type: "BookReserve", requestor_netid: 'netid', course: course)

        discovery_record = double(title: "title", creator_contributor: "creator_contributor", publisher_provider: "publisher_provider", details: "details")
        DiscoveryApi.stub(:search_by_ids).and_return([ discovery_record ])

        ReserveSynchronizeMetaData.any_instance.stub(:needs_to_be_synchronized?).and_return(true)

      end

      it "synchronizes the title" do
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
        @reserve.title.should == "title"
      end


      it "synchonizes the creator_contributor "  do
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
        @reserve.creator_contributor.should == "creator_contributor"
      end


      it "synchonizes the publisher_provider"  do
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
        @reserve.publisher_provider.should == "publisher_provider"
      end

      it "synchronizes the details "  do
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
        @reserve.details.should == "details"
      end


      it "sets the metadata_synchronization_date to time.now" do
        @reserve.metadata_synchronization_date.should == nil
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
        @reserve.metadata_synchronization_date.to_s.should == Time.now.to_s
      end

    end

    context "reserve cannot be synchronized" do

      before(:each) do
        @reserve = Reserve.new(nd_meta_data_id: "ndid", overwrite_nd_meta_data: false, metadata_synchronization_date: 11.days.ago)
      end

      it "runs the synchronization if there is a metadata id and metadata has not been overwritten and it is more then 10 days ago" do
        ReserveSynchronizeMetaData.any_instance.should_receive(:synchonize!)
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
      end


      it "does run the synchronization if the last sync date is nil " do
        @reserve.metadata_synchronization_date = nil
        ReserveSynchronizeMetaData.any_instance.should_receive(:synchonize!)
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
      end


      it "does not run the synchronization if the reserve does not have a metadata id" do
        @reserve.nd_meta_data_id = nil
        ReserveSynchronizeMetaData.any_instance.should_not_receive(:synchonize!)
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
      end


      it "does not run the synchronization if the meta data has been overwritten" do
        @reserve.overwrite_nd_meta_data = true
        ReserveSynchronizeMetaData.any_instance.should_not_receive(:synchonize!)
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
      end


      it "does not run the synchronization if the last sync was less then 10 days ago" do
        @reserve.metadata_synchronization_date = 9.days.ago
        ReserveSynchronizeMetaData.any_instance.should_not_receive(:synchonize!)
        ReserveSynchronizeMetaData.new(@reserve).check_synchronized!
      end

    end
  end
end
