require 'rails_helper'

RSpec.describe JobsController, :type => :controller do
  before(:all) do
    @share_link = create(:share_link, :with_job_permissions)
    @user = create(:user, :with_jobs)
  end

  [:@user, :@share_link].each do |user_variable_name|
    let(:user) { instance_variable_get(user_variable_name) }
    let(:job) { user.open_jobs.first }

    describe "GET #index" do
      let (:action) { get :index }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:template) { :index }
        let (:can_action) { :read_multiple }
        let (:can_param) { all(be_a(Job)) }

        context "with open jobs" do
          it { expect(assigns(:jobs)).to eq(user.open_jobs) }
        end

        context "with archived jobs" do
          let (:action) { get :index, archived: "true" }
          it { expect(assigns(:jobs)).to eq(user.archived_jobs) }
        end
      end
    end

    describe "GET #show" do
      let (:action) { get :show, id: job.id }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:template) { :show }
        let (:can_action) { :read }
        let (:can_param) { job }

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
      let (:action) { get :new }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:template) { :new }
        let (:can_action) { :create }
        let (:can_param) { be_a_new(Job) }

        it { expect(assigns(:job)).to be_a_new(Job) }

        it_behaves_like "a modal action" do
          let (:action) { get :new, format: 'modal' }
        end
      end
    end

    describe "POST #create" do
      let (:action) { post :create, job: { name: build(:job).name } }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:redirect_path) { jobs_path }
        let (:can_action) { :create }
        let (:can_param) { be_a_new(Job) }

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
      let (:action) { get :edit, id: job.id }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:template) { :new }
        let (:can_action) { :update }
        let (:can_param) { job }

        it { expect(assigns(:job)).to eq(job) }

        it_behaves_like "a modal action" do
          let (:action) { get :edit, id: job.id, format: 'modal' }
        end
      end
    end

    describe "PUT #update" do
      let (:new_job_name) { build(:job).name }
      let (:action) { put :update, id: job.id, job: { name: new_job_name } }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:redirect_path) { jobs_path(archived: assigns(:job).is_archived) }
        let (:can_action) { :update }
        let (:can_param) { job }

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
      let (:action) { get :should_delete, id: job.id }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:template) { :should_delete }
        let (:can_action) { :destroy }
        let (:can_param) { job }

        it { expect(assigns(:job)).to eq(job) }

        it_behaves_like "a modal action" do
          let (:action) { get :should_delete, id: job.id, format: 'modal' }
        end
      end
    end

    describe "DELETE #destroy" do
      let (:action) { delete :destroy, id: job.id }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:redirect_path) { jobs_path }
        let (:can_action) { :destroy }
        let (:can_param) { job }

        it { expect(assigns(:job)).to eq(job) }
        it { expect(assigns(:job).destroyed?).to be(true) }
      end
    end
  end
end
