module SpecLoginHepers
  def login(user)
    sign_in user
  end

  def logout
    sign_out :user
  end
end
