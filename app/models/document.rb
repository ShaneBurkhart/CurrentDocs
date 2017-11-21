class Document < ActiveRecord::Base
  belongs_to :document_association, polymorphic: true

  validates :document_association_id, :document_association_type, presence: true
  validates :s3_path, :original_filename, presence: true
  validates :s3_path, uniqueness: true
end
