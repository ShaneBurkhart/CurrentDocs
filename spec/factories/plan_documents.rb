# == Schema Information
#
# Table name: plan_documents
#
#  id         :integer          not null, primary key
#  plan_id    :integer          not null
#  is_current :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_plan_documents_on_is_current  (is_current)
#  index_plan_documents_on_plan_id     (plan_id)
#

FactoryBot.define do
  factory :plan_document do
    is_current true
    plan { create(:plan) }

    transient do
      has_document false
    end

    trait :as_history do
      is_current false
    end

    trait :with_document do
      has_document true
    end

    after(:create) do |plan_document, evaluator|
      has_document = evaluator.has_document

      if has_document
        create(:document, document_association: plan_document)
      end
    end
  end
end
