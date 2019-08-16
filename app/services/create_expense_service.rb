class CreateExpenseService
  include Wisper::Publisher

  def call(user, params)
    expense = user.expenses.create(params)
    return publish_error(expense) unless expense.valid?

    account = expense.account
    account.update!(amount: account.amount - expense.amount)
    publish(:expense_created, expense)
    expense
  end

  protected

  def publish_error(expense)
    publish(:expense_error, expense)
    false
  end
end
