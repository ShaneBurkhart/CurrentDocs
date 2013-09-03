class AboutController < ApplicationController
  def index
    @shane_url = User.avatar_url "shaneburkhart@gmail.com"
    @ryan_url = User.avatar_url "rzendacott@gmail.com"
  end
end
