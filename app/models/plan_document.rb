class PlanDocument < ActiveRecord::Base
  attr_accessible :plan_id, :document_id

  belongs_to :plan
  belongs_to :document

  validates :plan_id, :document_id, presence: true, uniqueness: true
  validate :not_in_plan_document_histories_for_plan

  private

    def not_in_plan_document_histories_for_plan
      doc_history_count = PlanDocumentHistory.where(
        plan_id: self.plan_id,
        document_id: self.document_id
      ).count

      if doc_history_count > 0
        errors.add(
          :document_id,
          'is in document histories for plan with ID #{self.plan_id}'
        )
      end
    end
end
