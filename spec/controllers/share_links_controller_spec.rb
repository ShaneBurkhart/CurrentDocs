require 'rails_helper'

RSpec.describe ShareLinksController, :type => :controller do
  let(:user) { @user }
  let(:job) { @job }

  before(:all) do
    @user = create(:user)
    @job = @user.open_jobs.first
  end

  describe "GET #new" do
    let (:action) { get :new, job_id: @job.id }

    it_behaves_like 'an unauthenticated controller action'

    it_behaves_like 'an authorized controller action' do
      let (:template) { :new }
      let(:authorize_params) { [ { action: :create, param: be_a_new(ShareLink) } ] }

      context "when job_id is present " do
        it { expect(assigns(:job)).to eq(job) }
      end

      context "when job_id is not present " do
        let (:action) { get :new }
        it { expect(assigns(:job)).to be_nil }
      end
    end
  end

  describe "POST #create" do
    let(:action) { post :create, {
      job_id: job.id,
      share_link: { name: build(:share_link).name }
    } }

    it_behaves_like 'an unauthenticated controller action'

    it_behaves_like 'an authorized controller action' do
      context "when creating a new share link" do
        let(:authorize_params) { [
          { action: :create, param: be_a_new(ShareLink) }
        ] }

        it { expect(assigns(:share_link)).not_to be_a_new(ShareLink) }
        it { expect(assigns(:share_link).user_id).to eq(user.id) }

        it_behaves_like "an invalid model action" do
          let(:template) { :new }
          let(:overrides) do
            allow_any_instance_of(ShareLink).to receive(:save).and_return(false)
          end
        end
      end

      context "when selecting an existing share link" do
        let(:share_link) { @share_link }
        let(:action) { post :create, {
          job_id: job.id, share_link_id: share_link.id
        } }

        before(:all) do
          @share_link = create(:share_link, user: @user)
        end

        it { expect(assigns(:share_link)).to eq(share_link) }
      end

      context "when job_id is present" do
        let(:redirect_path) { edit_job_permission_path(assigns(:job_permission)) }
        let(:authorize_params) { [
          { action: :create, param: be_a_new(ShareLink) },
          { action: :share, param: job }
        ] }

        it { expect(assigns(:job)).to eq(job) }
        it { expect(assigns(:job_permission)).to be_a(JobPermission) }
        it { expect(assigns(:job_permission).job_id).to eq(job.id) }
        it { expect(assigns(:job_permission).permissions_id)
          .to eq(assigns(:share_link).permissions.id) }
      end

      context "when job_id is not present" do
        let(:action) { post :create, {
          share_link: { name: build(:share_link).name }
        } }
        let(:redirect_path) { share_link_path(assigns(:share_link)) }

        it { expect(assigns(:job)).to be_nil }
        it { expect(assigns(:job_permission)).to be_nil }
      end
    end
  end
end
