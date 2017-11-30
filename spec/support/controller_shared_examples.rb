shared_examples "an unauthenticated controller action" do
  before(:each) do
    logout
    action
  end

  it { expect(response).to redirect_to(new_user_session_path) }
end

shared_examples "an authorized controller action" do
  before(:each) do
    authorize_params = authorize_params || []

    # Backwards compatibility for how we were doing authorization params.
    if defined? can_action and defined? can_param
      authorize_params.push({ action: can_action, param: can_param })
    end

    login

    allow(controller).to receive(:authorize!).and_return(true)

    # Allow let calls with overrides and allows
    overrides if defined? overrides

    if !authorize_params.empty?
      authorize_params.each do |params|
        expect(controller)
          .to receive(:authorize!).once
          .with(params[:action] || anything, params[:param] || anything)
      end
    end

    action
  end

  it "renders the correct template" do
    if defined? template
      expect(response).to be_authorized
      expect(response).to render_template(template)
    end
  end

  it "redirects to the correct path" do
    if defined? redirect_path
      expect(response).to redirect_to(redirect_path)
    end
  end
end

shared_examples "a modal action" do
  it { expect(response).to render_template(template, layout: false) }
  it { expect(response.headers["Content-Type"]).to include("text/html") }
end

shared_examples "an invalid model action" do
  it { expect(response).to render_template(template) }
end
