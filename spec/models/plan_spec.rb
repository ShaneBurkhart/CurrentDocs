require 'rails_helper'

RSpec.describe Plan, :type => :model do
  it { should belong_to(:job) }
  it { should have_one(:plan_document) }
  it { should have_one(:document) }
  it { should have_many(:plan_document_histories) }
  it { should have_many(:document_histories) }

  # TODO validations
end
