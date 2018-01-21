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

require 'rails_helper'

RSpec.describe PlanDocument, :type => :model do
  let(:plan_document) { @plan_document }

  before(:all) { @plan_document = create(:plan_document) }

  it { expect(subject).to belong_to(:plan) }
  it { expect(subject).to have_one(:document) }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:plan_id) }

    it "should not allow multiple current plan documents for plan" do
      current_doc = build(:plan_document, plan: plan_document.plan)

      expect(current_doc).not_to be_valid
    end
  end
end
