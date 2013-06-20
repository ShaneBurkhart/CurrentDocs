require 'spec_helper'

describe MobileController do

  describe "GET 'index'" do
    it "returns http success" do
      visit mobile_path
      response.should be_success
    end
  end

end
