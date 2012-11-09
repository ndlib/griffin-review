require "spec_helper"

describe Admin::OpenItemController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/open_item").should route_to("admin/open_item#index")
    end

    it "routes to #new" do
      get("/admin/open_item/new").should route_to("admin/open_item#new")
    end

    it "routes to #show" do
      get("/admin/open_item/1").should route_to("admin/open_item#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/open_item/1/edit").should route_to("admin/open_item#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/open_item").should route_to("admin/open_item#create")
    end

    it "routes to #update" do
      put("/admin/open_item/1").should route_to("admin/open_item#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/open_item/1").should route_to("admin/open_item#destroy", :id => "1")
    end

  end
end
