require 'rails_helper'

RSpec.describe Document, :type => :model do
  describe "validations" do
    subject { create(:document) }
    it { should validate_presence_of(:s3_path) }
    it { should validate_uniqueness_of(:s3_path) }
    it { should validate_presence_of(:original_filename) }
  end
end
