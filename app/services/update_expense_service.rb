class UpdateExpenseService
  include Wisper::Publisher

  def call(expense, params)
    original_account = expense.account
    original_amount = expense.amount

    expense.update(params)
    return publish_error(expense) unless expense.valid?

    if expense.amount != original_amount
      diff_amount = params[:amount].to_i - original_amount
      if diff_amount.positive?
        expense.account.update(amount: expense.account.amount - diff_amount)
      else
        expense.account.update(amount: expense.account.amount + diff_amount.abs)
      end
    end

    publish(:expense_updated, expense)
    expense
  end

  protected

  def publish_error(expense)
    publish(:expense_error, expense)
    false
  end
end
