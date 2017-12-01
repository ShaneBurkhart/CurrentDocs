require 'rails_helper'

RSpec.describe Document, :type => :model do
  let(:document) { @document }

  before(:all) { @document = create(:document) }

  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:document_association) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:document_association_id).on(:update) }
    it { expect(subject).to validate_presence_of(:document_association_type).on(:update) }
    it { expect(subject).to validate_presence_of(:s3_path) }
    it { expect(subject).to validate_uniqueness_of(:s3_path) }
    it { expect(subject).to validate_presence_of(:original_filename) }
    it { expect(subject).to validate_presence_of(:user_id) }
  end
end
