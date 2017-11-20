require 'rails_helper'

RSpec.describe JobsController, :type => :controller do
  let(:user) { create(:user) }
  let(:job) { user.open_jobs.first }

  describe "GET #index" do
    it_behaves_like 'an authorized controller action' do
      let (:action) { get :index }
      let (:template) { :index }
      let (:can_action) { :read_multiple }
      let (:can_param) { all(be_a(Job)) }

      context "with open jobs" do
        it { expect(assigns(:jobs)).to all(have_attributes(archived: false)) }
      end

      context "with archived jobs" do
        let (:action) { get :index, archived: "true" }
        it { expect(assigns(:jobs)).to all(have_attributes(archived: true)) }
      end
    end
  end

  describe "GET #show" do
    it_behaves_like 'an authorized controller action' do
      let (:action) { get :show, id: job.id }
      let (:template) { :show }
      let (:can_action) { :read }
      let (:can_param) { be_a(Job) }

      context "with no tab param" do
        it { expect(assigns(:job)).to have_attributes(id: job.id, name: job.name) }
      end

      context "with lowercase tab param" do
        let (:action) { get :show, id: job.id, tab: "addendums"}
        it { expect(assigns(:tab)).to eq("addendums") }
      end

      context "with uppercase tab param" do
        let (:action) { get :show, id: job.id, tab: "AddEndums"}
        it { expect(assigns(:tab)).to eq("addendums") }
      end
    end
  end

  describe "GET #new" do
    it_behaves_like 'an authorized controller action' do
      let (:action) { get :new }
      let (:template) { :new }
      let (:can_action) { :create }
      let (:can_param) { Job }

      it { expect(assigns(:job)).to be_a_new(Job) }

      it_behaves_like "a modal action" do
        let (:action) { get :new, format: 'modal' }
      end
    end
  end

  describe "POST #create" do
    it_behaves_like 'an authorized controller action' do
      let (:action) { post :create, job: { name: build(:job).name } }
      let (:redirect_path) { jobs_path }
      let (:can_action) { :create }
      let (:can_param) { Job }

      it { expect(assigns(:job)).not_to be_a_new(Job) }
      it { expect(assigns(:job).user_id).to eq(user.id) }

      it_behaves_like "an invalid model action" do
        let (:template) { :new }
        let(:overrides) do
          allow_any_instance_of(Job).to receive(:save).and_return(false)
        end
      end
    end
  end

  describe "GET #edit" do
    it_behaves_like 'an authorized controller action' do
      let (:action) { get :edit, id: job.id }
      let (:template) { :new }
      let (:can_action) { :update }
      let (:can_param) { eq(job) }

      it { expect(assigns(:job)).to eq(job) }

      it_behaves_like "a modal action" do
        let (:action) { get :edit, id: job.id, format: 'modal' }
      end
    end
  end

  describe "PUT #update" do
    it_behaves_like 'an authorized controller action' do
      let (:new_job_name) { build(:job).name }
      let (:action) { put :update, id: job.id, job: { name: new_job_name } }
      let (:redirect_path) { jobs_path }
      let (:can_action) { :update }
      let (:can_param) { eq(job) }

      it { expect(assigns(:job).id).to eq(job.id) }
      it { expect(assigns(:job).name).to eq(new_job_name) }

      context "with success_redirect_url" do
        let (:redirect_url) { "/custom" }
        let (:action) do
          put :update, {
            id: job.id,
            success_redirect_url: redirect_url,
            job: { name: new_job_name }
          }
        end

        it { expect(response).to redirect_to(redirect_url) }
      end

      it_behaves_like "an invalid model action" do
        let (:template) { :new }
        let(:overrides) do
          allow_any_instance_of(Job).to receive(:update_attributes).and_return(false)
        end
      end
    end
  end

  describe "GET #should_delete" do
    it_behaves_like 'an authorized controller action' do
      let (:action) { get :should_delete, id: job.id }
      let (:template) { :should_delete }
      let (:can_action) { :delete }
      let (:can_param) { eq(job) }

      it { expect(assigns(:job)).to eq(job) }

      it_behaves_like "a modal action" do
        let (:action) { get :should_delete, id: job.id, format: 'modal' }
      end
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like 'an authorized controller action' do
      let (:action) { delete :destroy, id: job.id }
      let (:redirect_path) { jobs_path }
      let (:can_action) { :destroy }
      let (:can_param) { eq(job) }

      it { expect(assigns(:job)).to eq(job) }
      it { expect(assigns(:job).destroyed?).to be(true) }
    end
  end
end
