class UpdateIncomeService < IncomeService
  def call(income, params)
    original_income = income.dup

    income.update(params)
    return publish_error(income) unless income.valid?

    if original_income.account.id != income.account.id
      account_service.decrease_amount(original_income, original_income.amount)
      account_service.increase_amount(income, income.amount)
    elsif income.amount != original_income.amount
      update_account(income, income.amount - original_income.amount)
    end
    publish(:income_updated, income)
    income
  end

  protected

  def update_account(income, amount)
    if amount.positive?
      account_service.increase_amount(income, amount)
    else
      account_service.decrease_amount(income, amount.abs)
    end
  end
end
