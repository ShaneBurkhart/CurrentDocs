require 'rails_helper'

RSpec.describe Job, :type => :model do
  it { should belong_to(:user) }
  it { should have_many(:plans) }
  it { should have_many(:share_links) }

  # TODO validations
end
