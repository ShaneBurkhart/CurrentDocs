require 'spec_helper'

describe PrintsController do
	describe "About Printing Page" do
    it "should be successful" do
      visit prints_path
      response.should be_success
    end
  end
end
