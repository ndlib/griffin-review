require 'spec_helper'

describe Admin::OpenItemController do
  
  before(:all) do
    @admin_role = Factory.create(:admin_role)
    @jane_user = Factory.create(:user)
    @admin_user = Factory.create(:user)
    @open_item = Factory.create(:open_item);
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OpenItemsController.
  def valid_session
    {}
  end

  describe "CREATE user" do
      
    before(:all) do 
      @admin_user.roles = [@admin_role]
    end

    it "should have a current_user" do
      sign_in @admin_user
      subject.current_user.should_not be_nil
      sign_out @admin_user
    end
  end

  describe "GET show" do
    it "assigns the requested open_item as @open_item" do
      sign_in @admin_user
      get :show, {:id => @open_item.item_id}
      assigns(:open_item).should eq(@open_item)
      sign_out @admin_user
    end
  end

  describe "GET new" do
    it "assigns a new open_item as @open_item" do
      sign_in @admin_user
      get :new, {}
      assigns(:open_item).should be_a_new(OpenItem)
      sign_out @admin_user
    end
  end

  describe "GET edit" do
    it "assigns the requested open_item as @open_item" do
      sign_in @admin_user
      get :edit, {:id => @open_item.item_id}
      assigns(:open_item).should eq(@open_item)
      sign_out @admin_user
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new OpenItem" do
        sign_in @admin_user
        expect {
          post :create, {:open_item => {:title => @open_item.title, :item_type => @open_item.item_type}}
        }.to change(OpenItem, :count).by(1)
        assigns(:open_item).destroy
        sign_out @admin_user
      end

      it "assigns a newly created open_item as @open_item" do
        sign_in @admin_user
        post :create, {:open_item => {:title => @open_item.title, :item_type => @open_item.item_type}}
        assigns(:open_item).should be_a(OpenItem)
        assigns(:open_item).should be_persisted
        assigns(:open_item).destroy
        sign_out @admin_user
      end

      it "redirects to the created open_item" do
        sign_in @admin_user
        post :create, {:open_item => {:title => @open_item.title, :item_type => @open_item.item_type}}
        response.should redirect_to(admin_open_item_url(OpenItem.last))
        assigns(:open_item).destroy
        sign_out @admin_user
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved open_item as @open_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        sign_in @admin_user
        OpenItem.stub(:save).and_return(false)
        post :create, {:open_item => {}}
        assigns(:open_item).should be_a_new(OpenItem)
        sign_out @admin_user
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        sign_in @admin_user
        OpenItem.stub(:save).and_return(false)
        post :create, {:open_item => {}}
        response.should render_template("new")
        sign_out @admin_user
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested open_item" do
        sign_in @admin_user
        @open_item.title = "Another Title"
        put :update, :id => @open_item.item_id, :open_item => @open_item.attributes
        get :edit, :id => @open_item.item_id
        assigns(:open_item).title.should eq("Another Title")
        sign_out @admin_user
      end

      it "assigns the requested open_item as @open_item" do
        sign_in @admin_user
        put :update, {:id => @open_item.item_id, :open_item => {:item_type => 'book'}}
        assigns(:open_item).should eq(@open_item)
        sign_out @admin_user
      end

      it "redirects to the open_item" do
        sign_in @admin_user
        put :update, {:id => @open_item.item_id, :open_item => {:item_type => 'video'}}
        response.should redirect_to(admin_open_item_url(@open_item))
        sign_out @admin_user
      end
    end

    describe "with invalid params" do
      it "assigns the open_item as @open_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        sign_in @admin_user
        OpenItem.stub(:save).and_return(false)
        put :update, {:id => @open_item.item_id, :open_item => {}}
        assigns(:open_item).should eq(@open_item)
        sign_out @admin_user
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested open_item" do
      sign_in @admin_user
      expect {
        delete :destroy, {:id => @open_item.item_id}
      }.to change(OpenItem, :count).by(-1)
      sign_out @admin_user
    end

  end

end
