module Common
	PAPERCLIP_OPTIONS = {
    :storage => :s3,
    :s3_credentials => {
    :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    :bucket => ENV["AWS_BUCKET"]
    },
    :path => ":attachment/:id.:extension",
    :bucket => ENV["AWS_BUCKET"]
  	}

	def get_s3_paperclip_options
		return PAPERCLIP_OPTIONS
	end
end