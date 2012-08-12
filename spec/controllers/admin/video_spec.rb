require 'spec_helper'

describe Admin::VideoController do
  
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
    @video = Factory.create(:video);
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in @admin_user
  end 

  after(:each) do
    @video.destroy
    sign_out @admin_user
  end

  describe "GET show" do
    it "assigns the requested item as @video" do
      get :show, {:id => @video.item_id}
      assigns(:video).title.should eq(@video.title)
      assigns(:video).should eq(@video)
    end
  end

  describe "GET new" do
    it "assigns a new video as @video" do
      get :new, {}
      assigns(:video).should be_a_new(Video)
    end
  end

  describe "GET edit" do
    it "assigns the requested video as @video" do
      get :edit, {:id => @video.item_id}
      assigns(:video).should eq(@video)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Video" do
        expect {
          post :create, {:video => {:title => @video.title, :url => @video.url, :item_type => @video.item_type}}
        }.to change(Video, :count).by(1)
      end

      it "assigns a newly created video as @video" do
        post :create, {:video => {:title => @video.title, :url => @video.url, :item_type => @video.item_type}}
        assigns(:video).should be_a(Video)
        assigns(:video).should be_persisted
      end

      it "redirects to the created video" do
        post :create, {:video => {:title => @video.title, :url => @video.url, :item_type => @video.item_type}}
        response.should redirect_to(admin_video_url(Video.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved video as @video" do
        # Trigger the behavior that occurs when invalid params are submitted
        Video.stub(:save).and_return(false)
        post :create, {:video => {}}
        assigns(:video).should be_a_new(Video)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Video.stub(:save).and_return(false)
        post :create, {:video => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested video" do
        # Assuming there are no other videos in the database, this
        # specifies that the Video created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        # Video.should_receive(:update_attributes) # .with({'these' => 'params'})
        # put :update, {:id => @video.item_id} # , :video => {'these' => 'params'}}
        pending "needs to be rewritten"
      end

      it "assigns the requested video as @video" do
        put :update, {:id => @video.item_id, :video => {:item_type => 'book'}}
        assigns(:video).should eq(@video)
      end

      it "redirects to the video" do
        put :update, {:id => @video.item_id, :video => {:item_type => 'video'}}
        response.should redirect_to(admin_video_url(@video))
      end
    end

    describe "with invalid params" do
      it "assigns the video as @video" do
        # Trigger the behavior that occurs when invalid params are submitted
        Video.stub(:save).and_return(false)
        put :update, {:id => @video.item_id, :video => {}}
        assigns(:video).should eq(@video)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        # Video.stub(:save).and_return(false)
        # put :update, {:id => @video.item_id, :video => {}}
        # response.should render_template("edit")
        pending "needs to be rewritten"
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested video record" do
      expect {
        delete :destroy, {:id => @video.item_id}
      }.to change(Video, :count).by(-1)
    end

    # it "redirects to the videos list" do
    #   video = Video.create! valid_attributes
    #   delete :destroy, {:id => @video_video_id}
    #   response.should redirect_to(videos_url)
    # end
  end

end
