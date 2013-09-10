require 'spec_helper'

describe AccountController do

  describe "GET 'select'" do
    it "returns http success" do
      get 'select'
      response.should be_success
    end
  end

end
