require 'spec_helper'
CourseListing

describe GetListingsController do

  describe :show do

    context 'requires copy right acceptance' do
      before(:each) do
        BookListing.any_instance.stub(:approval_required?).and_return(true)
      end

      it "renders the view if the course listing requires copyright acceptance" do
        get :show, id: 1
        response.should render_template("show")
      end

      it "downloads the item if the copyright accepetance has been accepted and it is a download item" do
        BookListing.any_instance.stub(:file).and_return("FILE")

        controller.should_receive(:send_file).and_return{controller.render :nothing => true}

        get :show, id: 1, accept_terms_of_service: 1
      end

      it "redirects if the copyright acceptance has has been accepted and it is a redirect item" do
        BookListing.any_instance.stub(:url).and_return("http://www.google.com")
        BookListing.any_instance.stub(:file).and_return(nil)

        get :show, id: 1, accept_terms_of_service: 1

        response.should redirect_to("http://www.google.com")
      end
    end


    context ' it does not requre copyright acceptance' do
      before(:each) do
        BookListing.any_instance.stub(:approval_required?).and_return(false)
      end

      it "downloads the file if it is a downloaded item " do
        BookListing.any_instance.stub(:file).and_return("FILE")
        controller.should_receive(:send_file).and_return{controller.render :nothing => true}

        get :show, id: 1
      end

      it "redirects if the file is a redierect item" do
        BookListing.any_instance.stub(:url).and_return("http://www.google.com")
        BookListing.any_instance.stub(:file).and_return(nil)

        get :show, id: 1
        response.should redirect_to("http://www.google.com")
      end
    end
  end

end
