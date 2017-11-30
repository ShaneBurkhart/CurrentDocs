require 'securerandom'

FactoryBot.define do
  factory :document do
    document_association { create(:plan_document) }
    original_filename { Faker::File.file_name() }
    s3_path { "plans/#{SecureRandom.uuid}.pdf" }
    user { create(:user) }
  end
end
