class VePicturesController < ApplicationController
  require 'base64'
  require 'openssl'
  require 'digest/sha1'

  before_filter :authenticate_user!, except: [:images]

  def index
    AWS.config(
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    )
    bucket = AWS.s3.buckets["vecarouselimages"]
    @images = bucket.objects
    @redirect_url = request.protocol + request.domain + "/ve_pictures"
    if request.domain == "localhost" then
      @redirect_url = request.protocol + request.domain + ":" + request.port.to_s + "/ve_pictures"
    end
    @expiration = Time.now + 10.minutes
    @policy_doc = [
      '{',
        '"expiration": "' + @expiration.strftime('%Y-%m-%dT%H:%M:%SZ') + '",',
        '"conditions": [',
          '{"bucket": "vecarouselimages"},',
          '["starts-with", "$key", ""],',
          '{"acl": "public-read"},',
          '{"success_action_redirect": "' + @redirect_url + '"},',
          '["starts-with", "$Content-Type", "image/"],',
          '["content-length-range", 0, 1048576]',
        ']',
      '}'
    ].join("\n")
    @policy = Base64.encode64(@policy_doc).gsub("\n","")

    @signature = Base64.encode64(
        OpenSSL::HMAC.digest(
              OpenSSL::Digest::Digest.new('sha1'),
              ENV['AWS_SECRET_ACCESS_KEY'],
              @policy
        )
    ).gsub("\n","")
  end

  def images
    bucket = AWS.s3.buckets["vecarouselimages"]
    @image_urls = bucket.objects.map do |image|
      image.url_for(:read).to_s
    end
    render json: {urls: @image_urls}
  end

  def destroy
    bucket = AWS.s3.buckets["vecarouselimages"]
    @image = bucket.objects[params["key"]]
    @image.delete
    redirect_to ve_pictures_path
  end
end
