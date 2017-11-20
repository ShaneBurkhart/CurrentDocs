module SpecUserControllerHelpers
  include Warden::Test::Helpers
  include Devise::TestHelpers

  def login
    @request.env['warden'] = warden
    allow(@request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  def logout
    @request.env['warden'] = warden
    allow(@request.env['warden'])
      .to receive(:authenticate!)
      .and_throw(:warden, { :scope => :user })
  end
end
