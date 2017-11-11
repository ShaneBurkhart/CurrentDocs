require 'rails_helper'

RSpec.describe Plan, :type => :model do
  it { expect(subject).to belong_to(:job) }
  it { expect(subject).to have_one(:plan_document) }
  it { expect(subject).to have_one(:document) }
  it { expect(subject).to have_many(:plan_document_histories) }
  it { expect(subject).to have_many(:document_histories) }

  # TODO validations
end
