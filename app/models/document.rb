class Document < ActiveRecord::Base
  belongs_to :plan

  validates :s3_path, :original_filename, presence: true
  validates :s3_path, uniqueness: true
end
