require 'rails_helper'

RSpec.describe IncomePolicy, type: :policy do
  subject(:income_policy) { described_class }

  let(:user) { User.new }

  permissions :update? do
    it 'denies access if user tries to updated not his income' do
      expect(income_policy).not_to permit(user, Income.new)
    end

    it 'grants access if income belongs to user' do
      expect(income_policy).to permit(user, Income.new(user: user))
    end
  end
end
