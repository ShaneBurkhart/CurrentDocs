class Document < ActiveRecord::Base
  attr_accessible :s3_path, :original_filename

  belongs_to :document_association, polymorphic: true
  belongs_to :user

  validates :document_association_id, presence: true, on: :update
  validates :document_association_type, presence: true, on: :update
  validates :s3_path, :original_filename, :user_id, presence: true
  validates :s3_path, uniqueness: true
end
