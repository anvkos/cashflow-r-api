class UpdateExpenseService
  include Wisper::Publisher

  def call(expense, params)
    original_account = expense.account
    original_amount = expense.amount

    expense.update(params)
    return publish_error(expense) unless expense.valid?

    if original_account.id != expense.account.id
      original_account.update(amount: original_account.amount + original_amount)
      update_current_account(expense.account, expense.amount)
    elsif expense.amount != original_amount
      update_current_account(expense.account, params[:amount].to_i - original_amount)
    end

    publish(:expense_updated, expense)
    expense
  end

  protected

  def update_current_account(account, diff_amount)
    if diff_amount.positive?
      account.update(amount: account.amount - diff_amount)
    else
      account.update(amount: account.amount + diff_amount.abs)
    end
  end

  def publish_error(expense)
    publish(:expense_error, expense)
    false
  end
end
