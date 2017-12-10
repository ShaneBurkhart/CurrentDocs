require 'rails_helper'

RSpec.describe RegistrationController, :type => :controller do
  before(:all) do
    @share_link = create(:share_link, :with_job_permissions)
    @user = create(:user, :with_jobs)
  end

  context "when current_user is @user" do
    let(:user) { @user }

    describe "GET #edit" do
      let (:action) { get :edit }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:template) { :edit }
        let(:authorize_params) { [ { action: :update, param: user } ] }
      end
    end

    describe "PUT #update" do
      let (:is_a_share_link) { user.is_a?(ShareLink) }
      let (:new_password) { "password2" }
      let (:action) {
        put :update, user: {
          password: new_password,
          password_confirmation: new_password,
          # Got this from User factory
          current_password: "password"
        }
      }

      after(:each) { user.update_with_password({
        current_password: new_password,
        password: "password",
        password_confirmation: "password"
      }) if !is_a_share_link }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:redirect_path) { jobs_path }
        let(:authorize_params) { [ { action: :update, param: user } ] }

        it_behaves_like "an invalid model action" do
          let (:template) { is_a_share_link ? nil : :edit }
          let (:redirect_path) { is_a_share_link ? jobs_path : nil }
          let(:overrides) do
            allow_any_instance_of(User)
              .to receive(:update_with_password).and_return(false)
          end
        end
      end
    end
  end

  context "when current_user is @share_link" do
    let(:user) { @share_link }

    describe "GET #edit" do
      let (:action) { get :edit }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:redirect_path) { jobs_path }
      end
    end

    describe "PUT #update" do
      let (:new_password) { "password2" }
      let (:action) {
        put :update, user: {
          password: new_password,
          password_confirmation: new_password,
          # Got this from User factory
          current_password: "password"
        }
      }

      it_behaves_like 'an unauthenticated controller action'

      it_behaves_like 'an authorized controller action' do
        let (:redirect_path) { jobs_path }
      end
    end
  end
end
