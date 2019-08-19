class ExpensePolicy < ApplicationPolicy
  def update?
    return true if user.present? && user == expense.user
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def expense
    record
  end
end
