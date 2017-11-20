shared_examples "unauthenticated_request" do
  context "when user is logged out" do
    before(:each) do
      sign_out
      action
    end

    it { expect(response).to redirect_to(new_user_session_path) }
  end
end

shared_examples "unauthorized_request" do
  context "when user is not authorized" do
    before(:each) do
      sign_in
      allow(controller).to receive(:authorize!).and_throw(CanCan::AccessDenied)
      action
    end

    it { expect(response).to redirect_to(redirect_path) }
  end
end

shared_examples "authorized_request" do
  context "when user is authenticated and authorized" do
    before(:each) do
      sign_in
      action
    end

    it { expect(response).to be_authorized }
  end
end
