require "spec_helper"

describe ResourceInfosController do
  describe "routing" do

    it "routes to #index" do
      get("/resource_infos").should route_to("resource_infos#index")
    end

    it "routes to #new" do
      get("/resource_infos/new").should route_to("resource_infos#new")
    end

    it "routes to #show" do
      get("/resource_infos/1").should route_to("resource_infos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/resource_infos/1/edit").should route_to("resource_infos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/resource_infos").should route_to("resource_infos#create")
    end

    it "routes to #update" do
      put("/resource_infos/1").should route_to("resource_infos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/resource_infos/1").should route_to("resource_infos#destroy", :id => "1")
    end

  end
end
