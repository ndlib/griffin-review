require 'spec_helper'

describe Admin::ItemController do
  
  before(:all) do
    @admin_role = Factory.create(:admin_role)
    @jane_user = Factory.create(:user)
    @admin_user = Factory.create(:user)
    @item = Factory.create(:item);
  end

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ItemsController.
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
    it "assigns the requested item as @item" do
      sign_in @admin_user
      get :show, {:id => @item.item_id}
      assigns(:item).should eq(@item)
      sign_out @admin_user
    end
  end

  describe "GET new" do
    it "assigns a new item as @item" do
      sign_in @admin_user
      get :new, {}
      assigns(:item).should be_a_new(Item)
      sign_out @admin_user
    end
  end

  describe "GET edit" do
    it "assigns the requested item as @item" do
      sign_in @admin_user
      get :edit, {:id => @item.item_id}
      assigns(:item).should eq(@item)
      sign_out @admin_user
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Item" do
        sign_in @admin_user
        expect {
          post :create, {:item => {:title => @item.title, :item_type => @item.item_type}}
        }.to change(Item, :count).by(1)
        assigns(:item).destroy
        sign_out @admin_user
      end

      it "assigns a newly created item as @item" do
        sign_in @admin_user
        post :create, {:item => {:title => @item.title, :item_type => @item.item_type}}
        assigns(:item).should be_a(Item)
        assigns(:item).should be_persisted
        assigns(:item).destroy
        sign_out @admin_user
      end

      it "redirects to the created item" do
        sign_in @admin_user
        post :create, {:item => {:title => @item.title, :item_type => @item.item_type}}
        response.should redirect_to(admin_item_url(Item.last))
        assigns(:item).destroy
        sign_out @admin_user
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved item as @item" do
        # Trigger the behavior that occurs when invalid params are submitted
        sign_in @admin_user
        Item.stub(:save).and_return(false)
        post :create, {:item => {}}
        assigns(:item).should be_a_new(Item)
        sign_out @admin_user
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        sign_in @admin_user
        Item.stub(:save).and_return(false)
        post :create, {:item => {}}
        response.should render_template("new")
        sign_out @admin_user
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested item" do
        # Assuming there are no other items in the database, this
        # specifies that the Item created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        # Item.should_receive(:update_attributes).with({'these' => 'params'})
        # put :update, {:id => @item.item_id, :item => {'these' => 'params'}}
        pending "needs to be rewritten"
      end

      it "assigns the requested item as @item" do
        sign_in @admin_user
        put :update, {:id => @item.item_id, :item => {:item_type => 'book'}}
        assigns(:item).should eq(@item)
        sign_out @admin_user
      end

      it "redirects to the item" do
        sign_in @admin_user
        put :update, {:id => @item.item_id, :item => {:item_type => 'video'}}
        response.should redirect_to(admin_item_url(@item))
        sign_out @admin_user
      end
    end

    describe "with invalid params" do
      it "assigns the item as @item" do
        # Trigger the behavior that occurs when invalid params are submitted
        sign_in @admin_user
        Item.stub(:save).and_return(false)
        put :update, {:id => @item.item_id, :item => {}}
        assigns(:item).should eq(@item)
        sign_out @admin_user
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        # Item.stub(:save).and_return(false)
        # put :update, {:id => @item.item_id, :item => {}}
        # response.should render_template("edit")
        pending "needs to be rewritten"
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested item" do
      sign_in @admin_user
      expect {
        delete :destroy, {:id => @item.item_id}
      }.to change(Item, :count).by(-1)
      sign_out @admin_user
    end

    # it "redirects to the items list" do
    #   item = Item.create! valid_attributes
    #   delete :destroy, {:id => @item_item_id}
    #   response.should redirect_to(admin_item_url)
    # end
  end

end
