require 'rails_helper'

RSpec.describe JobPermissionsController, :type => :controller do
  let(:user) { @user }
  let(:job_permission) { @job_permission }
  let(:share_link) { @job_permission.permissions.authenticatable }

  before(:all) do
    @user = create(:user)
    @job_permission = create(:job_permission)
  end

  describe "GET #edit" do
    let(:action) { get :edit, id: job_permission.id }

    it_behaves_like 'an unauthenticated controller action'

    it_behaves_like 'an authorized controller action' do
      let(:template) { :edit }
      let(:authorize_params) { [ { action: :update, param: job_permission } ] }

      it { expect(assigns(:share_link)).to eq(share_link) }
      it { expect(assigns(:job_permission)).to eq(job_permission) }
      it { expect(assigns(:tab_permissions)).to be_a(Array) }
      it { expect(assigns(:tab_permissions))
        .to include(a_kind_of(PlanTabPermission)) }
    end
  end

  describe "PUT #update" do
    let(:action) do
      put :update, {
        id: job_permission.id,
        job_permission: { "can_update": "1" },
        tab_permissions: {
          "plans": {
            "can_create": "0",
            "can_update": "1",
            "can_destroy": "0",
          },
          "addendums": {
            "can_create": "1",
            "can_update": "0",
            "can_destroy": "1",
          }
        }
      }
    end

    it_behaves_like 'an unauthenticated controller action'

    it_behaves_like 'an authorized controller action' do
      let(:redirect_path) { share_link_path(share_link) }
      let(:authorize_params) { [ { action: :update, param: job_permission } ] }
      let(:overrides) do
        expect_any_instance_of(JobPermission)
          .to receive(:update_permissions)
          .with({
            permissions: [:can_update],
            tabs: {
              "plans" => [:can_update],
              "addendums" => [:can_create, :can_destroy]
            },
          }).and_return(true)
      end

      it { expect(assigns(:share_link)).to eq(share_link) }
      it { expect(assigns(:job_permission)).to eq(job_permission) }
      it { expect(assigns(:tab_permissions)).to be_nil }

      it_behaves_like "an invalid model action" do
        let(:template) { :edit }
        let(:overrides) do
          allow_any_instance_of(JobPermission)
            .to receive(:update_permissions).and_return(false)
        end

        it { expect(assigns(:tab_permissions)).to be_a(Array) }
        it { expect(assigns(:tab_permissions))
          .to include(a_kind_of(PlanTabPermission)) }
      end
    end
  end
end
