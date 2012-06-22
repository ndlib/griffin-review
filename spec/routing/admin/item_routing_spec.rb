require "spec_helper"

describe Admin::ItemController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/item").should route_to("admin/item#index")
    end

    it "routes to #new" do
      get("/admin/item/new").should route_to("admin/item#new")
    end

    it "routes to #show" do
      get("/admin/item/1").should route_to("admin/item#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/item/1/edit").should route_to("admin/item#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/item").should route_to("admin/item#create")
    end

    it "routes to #update" do
      put("/admin/item/1").should route_to("admin/item#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/item/1").should route_to("admin/item#destroy", :id => "1")
    end

  end
end
