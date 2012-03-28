require 'spec_helper'

describe VideosController do
  render_views

  # build test recipe procedure
  before(:all) do
    @video = Factory.create(:video);
  end 

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VideosController.
  def valid_session
    {}
  end

  describe "GET show" do
    it "assigns the requested item as @video" do
      get :show, {:id => @video.item_id}, valid_session
      assigns(:video).title.should eq(@video.title)
      assigns(:video).should eq(@video)
    end
  end

  describe "GET new" do
    it "assigns a new video as @video" do
      get :new, {}, valid_session
      assigns(:video).should be_a_new(Video)
    end
  end

  describe "GET edit" do
    it "assigns the requested video as @video" do
      get :edit, {:id => @video.item_id}, valid_session
      assigns(:video).should eq(@video)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Video" do
        expect {
          post :create, {:video => {:title => @video.title, :item_type => @video.item_type}}, valid_session
        }.to change(Video, :count).by(1)
        assigns(:video).destroy
      end

      it "assigns a newly created video as @video" do
        post :create, {:video => {:title => @video.title, :item_type => @video.item_type}}, valid_session
        assigns(:video).should be_a(Video)
        assigns(:video).should be_persisted
        assigns(:video).destroy
      end

      it "redirects to the created video" do
        post :create, {:video => {:title => @video.title, :item_type => @video.item_type}}, valid_session
        response.should redirect_to(Video.last)
        assigns(:video).destroy
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved video as @video" do
        # Trigger the behavior that occurs when invalid params are submitted
        Video.any_instance.stub(:save).and_return(false)
        post :create, {:video => {}}, valid_session
        assigns(:video).should be_a_new(Video)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Video.any_instance.stub(:save).and_return(false)
        post :create, {:video => {}}, valid_session
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
        Video.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => @video.item_id, :video => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested video as @video" do
        put :update, {:id => @video.item_id, :video => {:item_type => 'book'}}, valid_session
        assigns(:video).should eq(@video)
      end

      it "redirects to the video" do
        put :update, {:id => @video.item_id, :video => {:item_type => 'video'}}, valid_session
        response.should redirect_to(@video)
      end
    end

    describe "with invalid params" do
      it "assigns the video as @video" do
        # Trigger the behavior that occurs when invalid params are submitted
        Video.any_instance.stub(:save).and_return(false)
        put :update, {:id => @video.item_id, :video => {}}, valid_session
        assigns(:video).should eq(@video)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Video.any_instance.stub(:save).and_return(false)
        put :update, {:id => @video.item_id, :video => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested video record" do
      expect {
        delete :destroy, {:id => @video.item_id}, valid_session
      }.to change(Video, :count).by(-1)
    end

    # it "redirects to the videos list" do
    #   video = Video.create! valid_attributes
    #   delete :destroy, {:id => @video_video_id}, valid_session
    #   response.should redirect_to(videos_url)
    # end
  end
end
