class AccountPolicy < ApplicationPolicy
  def update?
    return true if user.present? && user == account.user
  end

  private

  def account
    record
  end
end
