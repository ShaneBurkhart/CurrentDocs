class PlanDocument < ActiveRecord::Base
  belongs_to :plan
  has_one :document, as: :document_association

  validates :plan_id, presence: true
  validates :is_current, inclusion: { in: [ true, false ] }
  validate :one_current_document_for_plan, if: :is_current

  private

    def one_current_document_for_plan
      docs = PlanDocument.where(
        plan_id: self.plan_id,
        is_current: true,
      )

      if self.new_record?
        if docs.count > 0
          errors.add(
            :is_current,
            "is already set for plan with ID #{self.plan_id}"
          )
        end
      else
        docs.where(["id != ?", self.id])

        if docs.count > 0
          errors.add(
            :is_current,
            "is already set for plan with ID #{self.plan_id}"
          )
        end
      end
    end
end
