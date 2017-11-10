require 'rails_helper'

RSpec.describe DocumentHistory, :type => :model do
  it { should belong_to(:plan) }
  it { should have_one(:document) }
end
