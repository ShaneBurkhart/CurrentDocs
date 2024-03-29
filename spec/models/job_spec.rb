require 'rails_helper'

RSpec.describe Job, :type => :model do
  let(:job) { @job }

  before(:all) { @job = create(:job, :with_all_plans) }

  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to have_many(:all_plans) }
  it { expect(subject).to have_many(:plans).order('order_num ASC') }
  it { expect(subject).to have_many(:addendums).order('order_num ASC') }

  describe "validations" do
    it { expect(subject).to validate_presence_of(:user_id) }
    it { expect(subject).to validate_presence_of(:name) }

    it "should check for duplicate name for user" do
      new_job = build(:job, name: job.name, user: job.user)

      expect(new_job).not_to be_valid
    end
  end

  describe "#plans" do
    it { expect(job.plans).to all(have_attributes(tab: "plans")) }
  end

  describe "#addendums" do
    it { expect(job.addendums).to all(have_attributes(tab: "addendums")) }
  end

  describe "#new_plan" do
    it { expect(job.new_plan('plans')).to be_a(Plan) }
    it { expect(job.new_plan('addendums').job_id).to eq(job.id) }
    it { expect(job.new_plan('addendums').tab).to eq('addendums') }
  end
end
