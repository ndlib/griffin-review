require 'spec_helper'

describe AdminUpdateResource do

  before(:each) do
    @user = double(User, :username => 'admin')
    @course = double(Course, id: 'id', semester: FactoryGirl.create(:semester))

    Reserve.any_instance.stub(:course).and_return(@course)
  end


  describe :validations  do

    it "only allows pdfs to be set if it can have pdfs " do
      url_reserve = mock_reserve(FactoryGirl.create(:request, :video), @course)
      aur = AdminUpdateResource.new(@user, { :id => url_reserve.id, :admin_update_resource => { :pdf => 'filefile' }})
      aur.should have(1).error_on(:pdf)
    end


    it "only allows links to be set if it can have links " do
      pdf_reserve = mock_reserve(FactoryGirl.create(:request, :book_chapter), @course)
      aur = AdminUpdateResource.new(@user, { :id => pdf_reserve.id, :admin_update_resource => { :url => 'urlurl' }})
      aur.should have(1).error_on(:url)
    end


    it "renders a 404 if the type does not allow a file or a url " do
      reserve = mock_reserve(FactoryGirl.create(:request, :book), @course)
      lambda {
        AdminUpdateResource.new(@user, { :id => reserve.id })
      }.should raise_error ActionController::RoutingError
    end
  end


  describe :persistance do

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

  end

end
