require "spec_helper"

describe ThreadPartsController do
  describe "routing" do

    it "routes to #index" do
      get("/thread_parts").should route_to("thread_parts#index")
    end

    it "routes to #new" do
      get("/thread_parts/new").should route_to("thread_parts#new")
    end

    it "routes to #show" do
      get("/thread_parts/1").should route_to("thread_parts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/thread_parts/1/edit").should route_to("thread_parts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/thread_parts").should route_to("thread_parts#create")
    end

    it "routes to #update" do
      put("/thread_parts/1").should route_to("thread_parts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/thread_parts/1").should route_to("thread_parts#destroy", :id => "1")
    end

  end
end
