class IncomePolicy < ApplicationPolicy
  def update?
    return true if user.present? && user == income.user
  end

  private

  def income
    record
  end
end
