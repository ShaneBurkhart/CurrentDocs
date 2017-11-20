require 'rails_helper'

RSpec.describe "JobsRequests", :type => :request do
  let(:user) { create(:user) }
  let(:job) { user.jobs.first }

  describe "GET /jobs" do
    let(:action) { get jobs_path }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end

  describe "GET /jobs/:id" do
    let(:action) { get job_path(job) }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end

  describe "GET /jobs/new" do
    let(:action) { get new_job_path }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end

  describe "POST /jobs" do
    let(:action) { post jobs_path(job) }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end

  describe "GET /jobs/:id/edit" do
    let(:action) { get edit_job_path(job) }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end

  describe "PUT /jobs/:id" do
    let(:action) { put job_path(job) }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end

  describe "GET /jobs/:id/should_delete" do
    let(:action) { put should_delete_job_path(job) }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end

  describe "DELETE /jobs/:id" do
    let(:action) { delete job_path(job) }

    include_examples 'authorized_request'
    include_examples 'unauthenticated_request'

    include_examples 'unauthorized_request' do
      let(:redirect_path) { jobs_path }
    end
  end
end
