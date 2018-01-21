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

class Document < ActiveRecord::Base
  attr_accessible :s3_path, :original_filename

  belongs_to :document_association, polymorphic: true
  belongs_to :user

  validates :document_association_id, presence: true, on: :update
  validates :document_association_type, presence: true, on: :update
  validates :s3_path, :original_filename, :user_id, presence: true
  validates :s3_path, uniqueness: true

  def url
    return "https://s3.amazonaws.com/#{ENV['AWS_BUCKET']}/#{self.s3_path}"
  end
end
