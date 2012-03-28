require 'spec_helper'

describe ItemsController do

  # build test recipe procedure
  before(:all) do
    @item = Factory.create(:item);
  end 
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ItemsController.
  def valid_session
    {}
  end

  # describe "GET index" do
  #   it "assigns all items as @items" do
  #     get :index, {}, valid_session
  #     assigns(:items).should eq([item])
  #   end
  # end

  describe "GET show" do
    it "assigns the requested item as @item" do
      get :show, {:id => @item.item_id}, valid_session
      assigns(:item).should eq(@item)
    end
  end

  describe "GET new" do
    it "assigns a new item as @item" do
      get :new, {}, valid_session
      assigns(:item).should be_a_new(Item)
    end
  end

  describe "GET edit" do
    it "assigns the requested item as @item" do
      get :edit, {:id => @item.item_id}, valid_session
      assigns(:item).should eq(@item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Item" do
        expect {
          post :create, {:item => {:title => @item.title, :item_type => @item.item_type}}, valid_session
        }.to change(Item, :count).by(1)
        assigns(:item).destroy
      end

      it "assigns a newly created item as @item" do
        post :create, {:item => {:title => @item.title, :item_type => @item.item_type}}, valid_session
        assigns(:item).should be_a(Item)
        assigns(:item).should be_persisted
        assigns(:item).destroy
      end

      it "redirects to the created item" do
        post :create, {:item => {:title => @item.title, :item_type => @item.item_type}}, valid_session
        response.should redirect_to(Item.last)
        assigns(:item).destroy
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved item as @item" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, {:item => {}}, valid_session
        assigns(:item).should be_a_new(Item)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        post :create, {:item => {}}, valid_session
        response.should render_template("new")
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
        Item.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => @item.item_id, :item => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested item as @item" do
        put :update, {:id => @item.item_id, :item => {:item_type => 'book'}}, valid_session
        assigns(:item).should eq(@item)
      end

      it "redirects to the item" do
        put :update, {:id => @item.item_id, :item => {:item_type => 'video'}}, valid_session
        response.should redirect_to(@item)
      end
    end

    describe "with invalid params" do
      it "assigns the item as @item" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, {:id => @item.item_id, :item => {}}, valid_session
        assigns(:item).should eq(@item)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Item.any_instance.stub(:save).and_return(false)
        put :update, {:id => @item.item_id, :item => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested item" do
      expect {
        delete :destroy, {:id => @item.item_id}, valid_session
      }.to change(Item, :count).by(-1)
    end

    # it "redirects to the items list" do
    #   item = Item.create! valid_attributes
    #   delete :destroy, {:id => @item_item_id}, valid_session
    #   response.should redirect_to(items_url)
    # end
  end

end
