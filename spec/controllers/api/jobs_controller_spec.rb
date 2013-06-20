require 'spec_helper'

describe Api::JobsController do

  describe "index" do
    it "returns http success" do
      visit api_jobs_path
      response.should be_success
    end
  end

  describe "show" do
    it "returns http success" do
      visit api_job_path(1)
      response.should be_success
    end
  end
end
