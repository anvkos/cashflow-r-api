class ExpenseService
  include Wisper::Publisher

  attr_reader :account_service

  def initialize
    @account_service = AccountService.new
  end

  protected

  def publish_error(expense)
    publish(:expense_error, expense)
    expense
  end
end
