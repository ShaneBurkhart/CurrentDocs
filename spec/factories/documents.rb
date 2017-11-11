require 'securerandom'

FactoryBot.define do
  factory :document do
    original_filename { Faker::File.file_name() }
    s3_path { "plans/#{SecureRandom.uuid}.pdf" }
  end
end
