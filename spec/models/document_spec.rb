require 'rails_helper'

RSpec.describe Document, :type => :model do
  describe "validations" do
    subject { create(:document) }
    it { expect(subject).to validate_presence_of(:s3_path) }
    it { expect(subject).to validate_uniqueness_of(:s3_path) }
    it { expect(subject).to validate_presence_of(:original_filename) }
  end
end
