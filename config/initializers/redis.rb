require 'redis'
require "aws-sdk"

REDIS_CONFIG = YAML.load(File.open(Rails.root.join("config/redis.yml")))
default = REDIS_CONFIG[:default] || {}
config = default.merge(REDIS_CONFIG[Rails.env]) if REDIS_CONFIG[Rails.env]

Redis.current = Redis.new(config)

# TODO Add callback for expiring keys and delete them in s3
