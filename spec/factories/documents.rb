FactoryBot.define do
  factory :document do
    original_filename { Faker::File.file_name() }
    s3_path { Faker::File.file_name('plans') }
  end
end
