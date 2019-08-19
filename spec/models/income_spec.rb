require 'rails_helper'

RSpec.describe Income, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:account) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :amount }
    it { is_expected.to validate_numericality_of(:amount) }
    it { is_expected.to validate_presence_of :payment_at }
  end
end
