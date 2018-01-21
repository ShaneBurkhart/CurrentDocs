# == Schema Information
#
# Table name: documents
#
#  id                        :integer          not null, primary key
#  original_filename         :string(255)      not null
#  s3_path                   :string(255)      not null
#  user_id                   :integer          not null
#  document_association_id   :integer
#  document_association_type :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_documents_on_s3_path  (s3_path) UNIQUE
#  index_documents_on_user_id  (user_id)
#

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
