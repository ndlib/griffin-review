require 'spec_helper'

describe AdminUpdateMetaData do

  before(:each) do
    @course = double(Course, id: 'id')

    @reserve = Reserve.new(id: 'id', title: 'title', selection_title: "selection_title", creator: 'creator', details: 'details', publisher: 'publisher', journal_title: 'journal_title', length: 'length', nd_meta_data_id: 'nd_meta_data_id', overwrite_nd_meta_data: true)
    @reserve.stub(:save!).and_return(true)
  end


  describe :build_from_params do
    before(:each) do
      @controller = double(ApplicationController, params: { id: 'id' })
      ReserveSearch.any_instance.stub(:get).and_return(@reserve)
    end

    it "passes the reserve from the id to the object" do
      expect(AdminUpdateMetaData.build_from_params(@controller).reserve).to eq(@reserve)
    end


    it "passes the params from the controller to the reserve" do
      @controller.params[:admin_update_meta_data] = { title: 'newtitle'}

      expect(AdminUpdateMetaData.build_from_params(@controller).title).to eq('newtitle')
    end
  end


  describe :initialize do

    it "sets reserve attributes to the virtus attributes" do
      @form = AdminUpdateMetaData.new(@reserve, {})
      ['title', 'creator', 'details', 'publisher', 'journal_title', 'length', 'selection_title', 'nd_meta_data_id' ].each do | field |
        expect(@form.send(field)).to eq(field)
      end
      expect(@form.overwrite_nd_meta_data).to be_truthy
    end


    it "overwrites the values with what is in params" do
      params = {title: 'titleparams', creator: 'creatorparams', details: 'detailsparams', publisher: 'publisherparams', journal_title: 'journal_titleparams', length: 'lengthparams', selection_title: 'selection_titleparams', nd_meta_data_id: 'nd_meta_data_idparams', overwrite_nd_meta_data: false}
      @form = AdminUpdateMetaData.new(@reserve, params)

      ['title', 'creator', 'details', 'publisher', 'journal_title', 'length', 'selection_title', 'nd_meta_data_id'].each do | field |
        expect(@form.send(field)).to eq("#{field}params")
      end
      expect(@form.overwrite_nd_meta_data).to be_falsey
    end


    it "checks if the the state is at least in process" do
      ReserveCheckInprogress.any_instance.should_receive(:check!)
      @form = AdminUpdateMetaData.new(@reserve, {})
    end


    it "presets overwrite_nd_meta_data to false if it is nil on the model " do
      @reserve.overwrite_nd_meta_data=nil
      AdminUpdateMetaData.new(@reserve, {})
    end


    it "calls fixes the record id" do
    end


    it "trims the nd_meta_data_id " do
      @params = { nd_meta_data_id: ' asdf '}
      u = AdminUpdateMetaData.new(@reserve, @params)

      expect(u.nd_meta_data_id).to eq("00000asdf")
    end


    it "removes the ndu_aleph designation" do
      @params = { nd_meta_data_id: 'ndu_alephasdf'}

      u = AdminUpdateMetaData.new(@reserve, @params)

      expect(u.nd_meta_data_id).to eq("00000asdf")
    end
  end


  describe :validations do
    before(:each) do
      @course = double(Course, id: 'id')

      @reserve = Reserve.new(id: 1)
      @reserve.should_receive(:save!).and_return(true)

      @update_meta_data = AdminUpdateMetaData.new(@reserve, {})
    end


    it "does not require title if overwrite_nd_meta_data is false" do
      @update_meta_data.stub(:requires_nd_meta_data_id?).and_return(true)
      @update_meta_data.should have(0).error_on(:title)
    end


    it "requires title if overwrite_nd_meta_data is true" do
      @update_meta_data.stub(:requires_nd_meta_data_id?).and_return(false)
      @update_meta_data.title = nil
      @update_meta_data.should have(1).error_on(:title)
    end


    it "does not require creator if overwrite_nd_meta_data is false" do
      @update_meta_data.stub(:requires_nd_meta_data_id?).and_return(true)

      @update_meta_data.should have(0).error_on(:creator)
    end


    it "errors if the nd meta data id passed in is not valid" do
      @update_meta_data.nd_meta_data_id = "invalid id"

      @update_meta_data.stub(:test_meta_data_id?).and_return(true)
      ReserveSynchronizeMetaData.any_instance.stub(:valid_discovery_id?).and_return(false)

      @update_meta_data.should have(1).error_on(:nd_meta_data_id)
    end


    it "errors if the dedup id from primo is passed in " do
      @update_meta_data.nd_meta_data_id = "dedupaasdfasfdasafds"
      @update_meta_data.stub(:requires_nd_meta_data_id?).and_return(true)
      ReserveSynchronizeMetaData.any_instance.stub(:valid_discovery_id?).and_return(false)

      @update_meta_data.should have(1).error_on(:nd_meta_data_id)
    end


    it "returns false if the udates is invalid" do
      @update_meta_data.stub(:valid?).and_return(false)

      expect(@update_meta_data.save_meta_data).to be_falsey
    end


    it "requires creator if overwrite_nd_meta_data is true" do
      #@update_meta_data.stub(:requires_nd_meta_data_id?).and_return(false)

      #@update_meta_data.should have(1).error_on(:creator)
    end
  end


  describe :pers do
    before(:each) do
      @params
    end

  end

  describe :persistance do

    before(:each) do
      @course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
      @reserve = Reserve.new(id: 1, title: 'title', type: 'BookReserve', course: @course, requestor_netid: 'username')

    end

    describe "no record id" do
      before(:each) do
        @params = {}

        @update_admin_meta_data = AdminUpdateMetaData.new(@reserve, @params)
      end


      it "sets the reviewed to be true when it is saved" do
        expect(@reserve.reviewed?).to be_falsey

        @update_admin_meta_data.save_meta_data
        expect(@reserve.reviewed?).to be_truthy
      end


      it "returns true if the update is valid" do
        expect(@update_admin_meta_data.save_meta_data).to be_truthy
      end


      it "calls save! on the reserve " do
        @reserve.should_receive(:save!).twice

        @update_admin_meta_data.save_meta_data
      end


      it "checks to see if the item is complete" do
        ReserveCheckIsComplete.any_instance.should_receive(:check!)

        @update_admin_meta_data.save_meta_data
      end
    end


    describe "persistance add valid record id" do
      before(:each) do
        @params = {nd_meta_data_id: '224323426' }

        @update_admin_meta_data = AdminUpdateMetaData.new(@reserve, @params)

        #don't test with the validator
        AdminUpdateMetaData.any_instance.stub(:test_meta_data_id?).and_return(false)
      end


      it "attempts to synchronize the metadata id" do
        ReserveSynchronizeMetaData.any_instance.should_receive(:synchronize!)

        @update_admin_meta_data.save_meta_data
      end
    end


    describe "replaces the record id with a new one" do
      before(:each) do
        @reserve.nd_meta_data_id = "new_id"

        @params = {nd_meta_data_id: '224323426' }

        @update_admin_meta_data = AdminUpdateMetaData.new(@reserve, @params)

        #don't test with the validator
        AdminUpdateMetaData.any_instance.stub(:test_meta_data_id?).and_return(false)
        ReserveSynchronizeMetaData.any_instance.stub(:synchronize!).and_return(true)
      end


      it "attempts to synchronize the metadata id" do
        @update_admin_meta_data.save_meta_data

        expect(@reserve.nd_meta_data_id).to eq("224323426")
      end
    end


  end
end
