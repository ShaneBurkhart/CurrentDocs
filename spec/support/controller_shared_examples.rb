shared_examples "an unauthenticated controller action" do
  before(:each) do
    logout
    action
  end

  it { expect(response).to redirect_to(new_user_session_path) }
end

shared_examples "an authorized controller action" do
  before(:each) do
    authorize_can_action = anything
    authorize_can_param = anything

    # The can_action should always be a symbol
    authorize_can_action = can_action if defined? can_action
    # The can_param should always be a matcher
    authorize_can_param = can_param if defined? can_param

    login

    allow(controller).to receive(:authorize!).and_return(true)
    # Allow let calls with overrides and allows
    overrides if defined? overrides

    expect(controller)
      .to receive(:authorize!).once
      .with(authorize_can_action, authorize_can_param)

    action
  end

  if defined? template
    it { expect(response).to be_authorized }
    it { expect(response).to render_template(template) }
  end

  if defined? redirect_path
    it { expect(response).to redirect_to(redirect_path) }
  end
end

shared_examples "a modal action" do
  it { expect(response).to render_template(template, layout: false) }
  it { expect(response.headers["Content-Type"]).to include("text/html") }
end

shared_examples "an invalid model action" do
  it { expect(response).to render_template(template) }
end
