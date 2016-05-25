class PdfController < ApplicationController
  before_filter :authenticate_user!

  def index
    url = 'http://localhost:3000/system/plans/plans/000/000/251/original/Argonaut.pdf'
    pdf_params = { id: url }.to_param
    @pdf_url = url
    # puts pdf_url
    render :layout => false
  end

end
