require 'spec_helper'

describe AdminUpdateResource do

  before(:each) do
    @user = double(User, :username => 'admin')
    @course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))
  end


  describe "current resource methods" do
    before(:each) do
      @reserve = double(Reserve, id: 1, electronic_reserve?: true, course: @course)
      ReserveSearch.any_instance.stub(:get).and_return(@reserve)

      AdminUpdateResource.any_instance.should_receive(:check_is_complete!).and_return(true)
      @form = AdminUpdateResource.new(@user, { id: 1 })
    end


    it "#has_resource? returns what the electronic_reserve_policy says" do
      ElectronicReservePolicy.any_instance.stub(:has_resource?).and_return("whatever")
      expect(@form.has_resource?).to eq("whatever")
    end


    it "#current_resource_type returns what the electronic_reserve_policy says" do
      ElectronicReservePolicy.any_instance.stub(:electronic_resource_type).and_return("whatever")
      expect(@form.current_resource_type).to eq("whatever")
    end


    it "#current_resource_name returns what the electronic_reserve_policy says" do
      ElectronicReservePolicy.any_instance.stub(:resource_name).and_return("whatever")
      expect(@form.current_resource_name).to eq("whatever")
    end

    it "#course returns the current course" do
      expect(@form.course).to eq(@course)
    end
  end


  describe :validations  do

  end


  describe :persistance do

    before(:each) do
      Reserve.any_instance.stub(:course).and_return(@course)
    end

    it "saves a new file " do
      mock_file = fixture_file_upload(Rails.root.join('spec', 'files', 'test.pdf'), 'application/pdf')

      pdf_reserve = mock_reserve(FactoryGirl.create(:request, :book_chapter), @course)
      pdf_reserve.pdf.clear
      pdf_reserve.save!

      aur = AdminUpdateResource.new(@user, { :id => pdf_reserve.id, :admin_update_resource => { :pdf => mock_file }})

      aur.save_resource.should be_true
      aur.reserve.pdf.original_filename.should == "test.pdf"
    end


    it "saves a url" do
      url_reserve = mock_reserve(FactoryGirl.create(:request, :video), @course)
      url_reserve.url = nil
      url_reserve.save!

      aur = AdminUpdateResource.new(@user, { :id => url_reserve.id, :admin_update_resource => { :url => "url" }})

      aur.save_resource.should be_true
      aur.reserve.url.should == "url"
    end



    it "checks to seed if the item is complete" do
      ReserveCheckIsComplete.any_instance.should_receive(:check!)

      url_reserve = mock_reserve(FactoryGirl.create(:request, :video), @course)
      url_reserve.url = nil
      url_reserve.save!

      aur = AdminUpdateResource.new(@user, { :id => url_reserve.id, :admin_update_resource => { :url => "url" }})

      aur.save_resource
    end
  end
end
