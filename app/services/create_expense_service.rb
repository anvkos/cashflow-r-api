class CreateExpenseService < ExpenseService
  def call(user, params)
    expense = user.expenses.create(params)
    return publish_error(expense) unless expense.valid?

    account_service.decrease_amount(expense, expense.amount)
    publish(:expense_created, expense)
    expense
  end
end
