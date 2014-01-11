require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'delete'" do
    it "returns http success" do
      get 'delete'
      response.should be_success
    end
  end

  describe "GET 'demote'" do
    it "returns http success" do
      get 'demote'
      response.should be_success
    end
  end

end
