require 'rails_helper'

RSpec.describe AccountPolicy, type: :policy do
  subject(:account_policy) { described_class }

  let(:user) { User.new }

  permissions :update? do
    it 'denies access if user tries to updated not his account' do
      expect(account_policy).not_to permit(user, Account.new)
    end

    it 'grants access if account belongs to user' do
      expect(account_policy).to permit(user, Account.new(user: user))
    end
  end
end
