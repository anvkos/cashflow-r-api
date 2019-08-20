class CreateIncomeService < IncomeService
  def call(user, params)
    income = user.incomes.create(params)
    return publish_error(income) unless income.valid?

    account_service.increase_amount(income, income.amount)
    publish(:income_created, income)
    income
  end
end
