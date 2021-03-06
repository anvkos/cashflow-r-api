require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:accounts) }
    it { is_expected.to have_many(:expenses) }
    it { is_expected.to have_many(:incomes) }
  end
end
