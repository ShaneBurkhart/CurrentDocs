require 'rails_helper'

RSpec.describe JobPermissionsController, :type => :controller do
  let(:user) { @user }
  let(:job_permission) { @job_permission }

  before(:all) do
    @user = create(:user)
    @job_permission = create(:job_permission)
  end

  describe "GET #edit" do
    let (:action) { get :edit, id: job_permission.id }

    it_behaves_like 'an unauthenticated controller action'

    it_behaves_like 'an authorized controller action' do
      let (:template) { :edit }
      let(:authorize_params) { [ { action: :update, param: job_permission } ] }

      it { expect(assigns(:job_permission)).to eq(job_permission) }
    end
  end
end
