module Common
	# External API configs
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

	# Notification constants
	NOTIF_ACTIONS = { delete:'delete', upload:'upload' }
	PERMISSIBLE_NOTIF_ACTIONS_LIST = NOTIF_ACTIONS.stringify_keys.keys
	NOTIF_TARGET_TYPE = 'job'

	def is_bool(value)
		return ['true', 'True', '1', 1, true, 'TRUE'].include? value ? true : false
	end
end
