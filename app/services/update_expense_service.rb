class UpdateExpenseService < ExpenseService
  def call(expense, params)
    original_expense = expense.dup

    expense.update(params)
    return publish_error(expense) unless expense.valid?

    if original_expense.account.id != expense.account.id
      account_service.increase_amount(original_expense, original_expense.amount)
      account_service.decrease_amount(expense, expense.amount)
    elsif expense.amount != original_expense.amount
      update_account(expense, expense.amount - original_expense.amount)
    end

    publish(:expense_updated, expense)
    expense
  end

  protected

  def update_account(expense, amount)
    if amount.positive?
      account_service.decrease_amount(expense, amount)
    else
      account_service.increase_amount(expense, amount.abs)
    end
  end
end
