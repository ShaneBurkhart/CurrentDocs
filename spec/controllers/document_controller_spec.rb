require 'rails_helper'

RSpec.describe DocumentController, :type => :controller do
  let (:user) { create(:user) }
  let (:document) { create(:document, user: user) }

  describe "POST #upload" do
    let (:file_upload) { fixture_file_upload('/upload_fixture.pdf', 'applicatino/pdf') }
    let (:action) { post :upload, files: { "0": file_upload, "1": file_upload } }

    it_behaves_like 'an unauthenticated controller action'

    it_behaves_like 'an authorized controller action' do
      let (:can_action) { :upload }
      let (:can_param) { Document }
      let (:response_json) { JSON.parse(response.body) }
      let (:overrides) do
        object_double = mock_s3_object()

        expect(object_double).to receive(:write).twice
          .with(file_upload.tempfile)

        expect(Document).to receive(:create).twice
          .and_return(document)
      end

      it { expect(response_json['files'].length).to eq(2) }
      it { expect(response_json['files'].first['id']).to eq(document.id) }
      it { expect(response_json['files'].first['original_filename'])
        .to eq(document.original_filename) }
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
      it { expect(response.headers["Content-Type"])
        .to eq('application/octet-stream') }
      it { expect(response.headers["Content-Disposition"])
        .to eq("attachment; filename=\"#{document.original_filename}\"") }
    end
  end
end
