class IncomeService
  include Wisper::Publisher

  attr_reader :account_service

  def initialize
    @account_service = AccountService.new
  end

  protected

  def publish_error(income)
    publish(:income_error, income)
    income
  end
end
