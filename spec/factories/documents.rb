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

require 'securerandom'

FactoryBot.define do
  factory :document do
    document_association { create(:plan_document) }
    original_filename { Faker::File.file_name() }
    s3_path { "plans/#{SecureRandom.uuid}.pdf" }
    user { create(:user) }
  end
end
