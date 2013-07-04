require "spec_helper"

describe Api::JobsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/jobs").should route_to("api/jobs#index")
    end

    it "routes to #show" do
      get("/api/jobs/1").should route_to("api/jobs#show", :id => "1")
    end

    it "routes to #create" do
      post("/api/jobs").should route_to("api/jobs#create")
    end

    it "routes to #update" do
      put("/api/jobs/1").should route_to("api/jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/api/jobs/1").should route_to("api/jobs#destroy", :id => "1")
    end

  end
end
