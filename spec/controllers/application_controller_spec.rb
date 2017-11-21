require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  # Implement index so we can stub it
  controller do
    def index
    end
  end

  it "redirects when record not found" do
    allow(controller)
      .to receive(:index)
      .and_raise(ActiveRecord::RecordNotFound)

    get :index

    expect(response).to redirect_to(jobs_path)
  end

  it "redirects when access denied" do
    allow(controller)
      .to receive(:index)
      .and_raise(CanCan::AccessDenied)

    get :index

    expect(response).to redirect_to(jobs_path)
  end
end
