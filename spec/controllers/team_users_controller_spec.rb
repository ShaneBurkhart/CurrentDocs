require 'rails_helper'

RSpec.describe TeamUsersController, :type => :controller do
  before(:all) do
    @user = create(:user)
    @user = create(:user, :with_share_links, :with_jobs)
  end

end
