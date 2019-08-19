require 'rails_helper'

RSpec.describe ExpensePolicy, type: :policy do
  subject(:expense_policy) { described_class }

  let(:user) { User.new }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    it 'denies access if user tries to updated not his expense' do
      expect(expense_policy).not_to permit(user, Expense.new)
    end

    it 'grants access if expense belongs to user' do
      expect(expense_policy).to permit(user, Expense.new(user: user))
    end
  end
end
