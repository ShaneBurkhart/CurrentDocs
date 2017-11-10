require 'rails_helper'

RSpec.describe Plan, :type => :model do
  it { should belong_to(:job) }
  it { should have_one(:document) }
  it { should has_many(:document_histories) }
end
