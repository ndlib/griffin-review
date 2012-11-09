require 'spec_helper'

describe Admin::OpenVideoController do
  
  before(:all) do
    @admin_role = Factory.create(:admin_role)
    @jane_user = Factory.create(:user)
    @admin_user = Factory.create(:user)
    @admin_user.roles = [@admin_role]
  end

  after(:all) do
    @jane_user.destroy
    @admin_user.destroy
    @admin_role.destroy
  end

  before(:each) do
    @open_video = Factory.create(:open_video);
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @admin_user
  end 

  after(:each) do
    @open_video.destroy
    sign_out @admin_user
  end

  describe "GET show" do
    it "assigns the requested item as @open_video" do
      get :show, {:id => @open_video.item_id}
      assigns(:open_video).title.should eq(@open_video.title)
      assigns(:open_video).should eq(@open_video)
    end
  end

  describe "GET new" do
    it "assigns a new open_video as @open_video" do
      get :new, {}
      assigns(:open_video).should be_a_new(OpenVideo)
    end
  end

  describe "GET edit" do
    it "assigns the requested open_video as @open_video" do
      get :edit, {:id => @open_video.item_id}
      assigns(:open_video).should eq(@open_video)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new OpenVideo" do
        expect {
          post :create, {:open_video => {:title => @open_video.title, :url => @open_video.url, :item_type => @open_video.item_type}}
        }.to change(OpenVideo, :count).by(1)
      end

      it "assigns a newly created open_video as @open_video" do
        post :create, {:open_video => {:title => @open_video.title, :url => @open_video.url, :item_type => @open_video.item_type}}
        assigns(:open_video).should be_a(OpenVideo)
        assigns(:open_video).should be_persisted
      end

      it "redirects to the created open_video" do
        post :create, {:open_video => {:title => @open_video.title, :url => @open_video.url, :item_type => @open_video.item_type}}
        response.should redirect_to(admin_open_video_url(OpenVideo.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved open_video as @open_video" do
        # Trigger the behavior that occurs when invalid params are submitted
        OpenVideo.stub(:save).and_return(false)
        post :create, {:open_video => {}}
        assigns(:open_video).should be_a_new(OpenVideo)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        OpenVideo.stub(:save).and_return(false)
        post :create, {:open_video => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested open_video" do
        @open_video.title = "Another Title"
        put :update, :id => @open_video.item_id, :open_video => @open_video.attributes
        get :edit, :id => @open_video.item_id
        assigns(:open_video).title.should eq("Another Title")
      end

      it "assigns the requested open_video as @open_video" do
        put :update, {:id => @open_video.item_id, :open_video => {:item_type => 'book'}}
        assigns(:open_video).should eq(@open_video)
      end

      it "redirects to the open_video" do
        put :update, {:id => @open_video.item_id, :open_video => {:item_type => 'video'}}
        response.should redirect_to(admin_open_video_url(@open_video))
      end
    end

    describe "with invalid params" do
      it "assigns the open_video as @open_video" do
        # Trigger the behavior that occurs when invalid params are submitted
        OpenVideo.stub(:save).and_return(false)
        put :update, {:id => @open_video.item_id, :open_video => {}}
        assigns(:open_video).should eq(@open_video)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested open_video record" do
      expect {
        delete :destroy, {:id => @open_video.item_id}
      }.to change(OpenVideo, :count).by(-1)
    end
  end

end
