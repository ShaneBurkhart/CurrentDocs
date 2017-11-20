module SpecUserRequestHelpers
  include Warden::Test::Helpers
  include Devise::TestHelpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in
    login_as(user, scope: :user)
  end

  def sign_out
    logout(:user)
  end
end
