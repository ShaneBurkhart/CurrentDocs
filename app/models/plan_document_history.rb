class PlanDocumentHistory < ActiveRecord::Base
  attr_accessible :plan_id, :document_id

  belongs_to :plan
  belongs_to :document

  validates :document_id, uniqueness: true
  validates :plan_id, :document_id, presence: true
  validate :not_current_plan_document_for_plan

  private

    def not_current_plan_document_for_plan
      current_doc_count = PlanDocument.where(
        plan_id: self.plan_id,
        document_id: self.document_id
      ).count

      if current_doc_count > 0
        errors.add(
          :document_id,
          'is the current document for plan with ID #{self.plan_id}'
        )
      end
    end
end
