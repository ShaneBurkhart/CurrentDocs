require 'rails_helper'

RSpec.describe Document, :type => :model do
  it { should belong_to(:plan) }
  it { should belong_to(:document_history) }
end
