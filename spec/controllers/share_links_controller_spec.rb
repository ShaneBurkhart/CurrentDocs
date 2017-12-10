require 'rails_helper'

RSpec.describe ShareLinksController, :type => :controller do
  before(:all) do
    @share_link = create(:share_link, :with_job_permissions)
    @user = create(:user, :with_share_links, :with_jobs)
  end

  describe "GET #login" do
    let(:user) { @user }
    let (:action) { get :login, token: @share_link.token }

    it_behaves_like 'an authorized controller action' do
      let (:redirect_path) { jobs_path }

      it { expect(assigns(:share_link)).to eq(@share_link) }
      it { expect(session[:share_link_token]).to eq(@share_link.token) }
    end
  end

  [:@user, :@share_link].each do |user_variable_name|
    context "when current_user is #{user_variable_name}" do
      let(:user) { @current_user }
      let(:share_link) { @share_link }
      let(:job) { @job }

      before(:all) do
        @current_user = instance_variable_get(user_variable_name)

        if @current_user.is_a?(ShareLink)
          @share_link = create(:share_link)
          @job = create(:job)
        else
          @share_link = @current_user.share_links.first
          @job = create(:job, user: @current_user)
        end
      end

      describe "GET #index" do
        let (:action) { get :index }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :index }
          let(:authorize_params) { [
            { action: :read_multiple, param: user.is_a?(User) ? all(be_a(ShareLink)) : nil }
          ] }

          it { expect(assigns(:share_links)).to eq(user.share_links) }
        end
      end

      describe "GET #show" do
        let (:action) { get :show, id: share_link.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :show }
          let(:authorize_params) { [
            { action: :read, param: be_a(ShareLink) }
          ] }

          it { expect(assigns(:share_link)).to eq(share_link) }
          it { expect(assigns(:unshared_jobs)).to all(be_a(Job)) }

          it "excludes shared jobs from @unshared_jobs" do
            jobs_to_exclude = share_link.permissions.job_permissions.map do |jp|
              jp.job
            end

            expect(assigns(:unshared_jobs)).not_to include(jobs_to_exclude)
          end
        end
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
            let(:action) { post :create, {
              job_id: job.id, share_link_id: share_link.id
            } }

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

      describe "GET #edit" do
        let (:action) { get :edit, id: share_link.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :edit }
          let (:can_action) { :update }
          let (:can_param) { share_link }

          it { expect(assigns(:share_link)).to eq(share_link) }

          it_behaves_like "a modal action" do
            let (:action) { get :edit, id: share_link.id, format: 'modal' }
          end
        end
      end

      describe "PUT #update" do
        let (:new_share_link_name) { Faker::Name.name }
        let (:action) {
          put :update, id: share_link.id, share_link: { name: new_share_link_name }
        }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:redirect_path) { share_links_path }
          let (:can_action) { :update }
          let (:can_param) { share_link }

          it { expect(assigns(:share_link).id).to eq(share_link.id) }
          it { expect(assigns(:share_link).name).to eq(new_share_link_name) }

          context "with success_redirect_url" do
            let (:redirect_url) { "/custom" }
            let (:action) do
              put :update, {
                id: share_link.id,
                success_redirect_url: redirect_url,
                share_link: { name: new_share_link_name }
              }
            end

            it { expect(response).to redirect_to(redirect_url) }
          end

          it_behaves_like "an invalid model action" do
            let (:template) { :edit }
            let(:overrides) do
              allow_any_instance_of(ShareLink)
                .to receive(:update_attributes).and_return(false)
            end
          end
        end
      end

      describe "GET #should_delete" do
        let (:action) { get :should_delete, id: share_link.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :should_delete }
          let (:can_action) { :destroy }
          let (:can_param) { share_link }

          it { expect(assigns(:share_link)).to eq(share_link) }

          it_behaves_like "a modal action" do
            let (:action) { get :should_delete, id: share_link.id, format: 'modal' }
          end
        end
      end

      describe "DELETE #destroy" do
        let (:action) { delete :destroy, id: share_link.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:redirect_path) { share_links_path }
          let (:can_action) { :destroy }
          let (:can_param) { share_link }

          it { expect(assigns(:share_link)).to eq(share_link) }
          it { expect(assigns(:share_link).destroyed?).to be(true) }
        end
      end
    end
  end
end
