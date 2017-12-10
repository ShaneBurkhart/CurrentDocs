require 'rails_helper'

RSpec.describe PlansController, :type => :controller do
  before(:all) do
    @share_link = create(:share_link, :with_open_job_permissions)
    @user = create(:user, :with_open_jobs)
  end

  [:@user, :@share_link].each do |user_variable_name|
    context "when current_user is #{user_variable_name}" do
      let(:user) { @user }
      let(:plan) { @plan }
      let(:addendum) { @addendum }
      let(:job) { @job }
      let(:document) { create(:document) }

      before(:all) do
        @user = instance_variable_get(user_variable_name)

        if @user.is_a?(ShareLink)
          @job = @user.permissions.job_permissions.first.job
        else
          @job = @user.open_jobs.first
        end

        @plan = create(:plan, :as_plan, job: @job)
        @addendum = create(:plan, :as_addendum, job: @job)
      end

      describe "GET #show" do
        let (:action) { get :show, id: addendum.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :show }
          let (:can_action) { :read }
          let (:can_param) { addendum }

          it { expect(assigns(:plan)).to eq(addendum) }

          it_behaves_like "a modal action" do
            let (:action) { get :show, id: addendum.id, format: 'modal' }
          end
        end
      end

      describe "GET #new" do
        let (:action) { get :new, job_id: job.id, tab: addendum.tab }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :new }
          let (:can_action) { :create }
          let (:can_param) { be_a_new(Plan) }

          it { expect(assigns(:plan)).to be_a_new(Plan) }
          it { expect(assigns(:plan))
              .to have_attributes({ job_id: job.id, tab: addendum.tab }) }

          it_behaves_like "a modal action" do
            let (:action) { get :new, job_id: job.id, tab: plan.tab, format: 'modal' }
          end
        end
      end

      describe "POST #create" do
        let (:action) { post :create, {
          job_id: job.id,
          tab: addendum.tab,
          document_id: document.id,
          plan: build(:plan).attributes.slice('name')
        } }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:redirect_path) { job_tab_path(job.id, addendum.tab) }
          let (:can_action) { :create }
          let (:can_param) { be_a_new(Plan) }

          it { expect(assigns(:plan)).not_to be_a_new(Plan) }
          it { expect(assigns(:plan))
                .to have_attributes({ job_id: job.id, tab: addendum.tab }) }

          it_behaves_like "an invalid model action" do
            let (:template) { :new }
            let(:overrides) do
              allow_any_instance_of(Plan).to receive(:save).and_return(false)
            end
          end

          it_behaves_like "an invalid model action" do
            let (:template) { :new }
            let(:overrides) do
              allow_any_instance_of(Plan)
                .to receive(:save).and_return(true)
              allow_any_instance_of(Plan)
                .to receive(:update_document).and_return(false)
            end
          end
        end
      end

      describe "GET #edit" do
        let (:action) { get :edit, id: addendum.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :new }
          let (:can_action) { :update }
          let (:can_param) { addendum }

          it { expect(assigns(:plan)).to eq(addendum) }

          it_behaves_like "a modal action" do
            let (:action) { get :edit, id: addendum.id, format: 'modal' }
          end
        end
      end

      describe "PUT #update" do
        let (:new_plan_name) { build(:plan).name }
        let (:action) { put :update, id: addendum.id, document_id: document.id, plan: { name: new_plan_name } }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:redirect_path) { job_tab_path(job.id, addendum.tab) }
          let (:can_action) { :update }
          let (:can_param) { addendum }

          it { expect(assigns(:plan).id).to eq(addendum.id) }
          it { expect(assigns(:plan).name).to eq(new_plan_name) }
          it { expect(assigns(:plan))
                .to have_attributes({ job_id: job.id, tab: addendum.tab }) }

          it_behaves_like "an invalid model action" do
            let (:template) { :new }
            let(:overrides) do
              allow_any_instance_of(Plan)
                .to receive(:update_attributes).and_return(false)
            end
          end

          it_behaves_like "an invalid model action" do
            let (:template) { :new }
            let(:overrides) do
              allow_any_instance_of(Plan)
                .to receive(:update_attributes).and_return(true)
              allow_any_instance_of(Plan)
                .to receive(:update_document).and_return(false)
            end
          end
        end
      end

      describe "GET #should_delete" do
        let (:action) { get :should_delete, id: addendum.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :should_delete }
          let (:can_action) { :destroy }
          let (:can_param) { addendum }

          it { expect(assigns(:plan)).to eq(addendum) }

          it_behaves_like "a modal action" do
            let (:action) { get :should_delete, id: addendum.id, format: 'modal' }
          end
        end
      end

      describe "DELETE #destroy" do
        let (:action) { delete :destroy, id: addendum.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:redirect_path) { job_tab_path(job.id, addendum.tab) }
          let (:can_action) { :destroy }
          let (:can_param) { addendum }

          it { expect(assigns(:plan)).to eq(addendum) }
          it { expect(assigns(:plan).destroyed?).to be(true) }
        end
      end
    end
  end
end
