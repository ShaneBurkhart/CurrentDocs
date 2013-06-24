module Login
	def self.API_login
		render :text => "No user logged in" unless user_signed_in?
	end
end