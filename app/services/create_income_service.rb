class CreateIncomeService
  include Wisper::Publisher

  def call(user, params)
    income = user.incomes.create(params)
    return publish_error(income) unless income.valid?

    account = income.account
    account.update!(amount: account.amount + income.amount)
    publish(:income_created, income)
    income
  end

  protected

  def publish_error(income)
    publish(:income_error, income)
    income
  end
end
