require 'rails_helper'

RSpec.describe DocumentController, :type => :controller do
  before(:all) do
    @share_link = create(:share_link)
    @user = create(:user)
  end

  [:@user, :@share_link].each do |user_variable_name|
    context "when current_user is #{user_variable_name}" do
      let(:user) { instance_variable_get(user_variable_name) }
      let(:document) { @document }

      before(:all) { @document = create(:document) }

      describe "GET #show" do
        let (:action) { get :show, id: document.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:template) { :show }
          let (:can_action) { :read }
          let (:can_param) { document }

          it { expect(assigns(:document)).to eq(document) }
        end
      end

      describe "POST #upload" do
        let (:file_upload) { fixture_file_upload('/upload_fixture.pdf', 'applicatino/pdf') }
        let (:action) { post :upload, files: { "0": file_upload, "1": file_upload } }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:can_action) { :upload }
          let (:can_param) { Document }
          let (:response_json) { JSON.parse(response.body) }
          let (:document_count) { 2 }
          let (:overrides) do
            object_double = mock_s3_object()

            expect(object_double).to receive(:write).exactly(document_count).times
              .with(file_upload.tempfile)
            expect(object_double).to receive(:acl=).exactly(document_count).times
              .with(:public_read)

            expect(Document).to receive(:create).exactly(document_count).times
              .and_return(document)
          end

          it { expect(response_json['files'].length).to eq(document_count) }
          it { expect(response_json['files'].first['id']).to eq(document.id) }
          it { expect(response_json['files'].first['original_filename'])
            .to eq(document.original_filename) }

          context "with a single file uploaded" do
            let (:document_count) { 1 }
            let (:action) { post :upload, files: file_upload }
            it { expect(response_json['files'].length).to eq(document_count) }
          end
        end
      end

      describe "GET #download" do
        let (:action) { get :download, id: document.id }

        it_behaves_like 'an unauthenticated controller action'

        it_behaves_like 'an authorized controller action' do
          let (:file_data) { "data" }
          let (:can_action) { :download }
          let (:can_param) { document }
          let (:overrides) do
            object_double = mock_s3_object()

            expect(object_double).to receive(:read).once.and_return(file_data)
          end

          it { expect(assigns(:document)).to eq(document) }
          it { expect(response.body).to eq(file_data) }
          it { expect(response.headers["Content-Disposition"])
            .to eq("attachment; filename=\"#{document.original_filename}\"") }
        end
      end
    end
  end
end
