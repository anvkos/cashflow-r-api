module Api
  module V1
    class ExpensesController < Api::V1::BaseController
      before_action :set_expense, only: [:update]

      def create
        service = CreateExpenseService.new
        service.on(:expense_created) { |expense| render json: expense, status: :created, adapter: :json }
        service.on(:expense_error) { |expense| respond_with_validation_error(expense) }
        @expense = service.call(current_user, expense_params)
      end

      def update
        service = UpdateExpenseService.new
        service.on(:expense_updated) { |expense| render json: expense, adapter: :json }
        service.on(:expense_error) { |expense| respond_with_validation_error(expense) }
        @expense = service.call(@expense, expense_params)
      end

      private

      def expense_params
        params.require(:expense).permit(:category_id, :account_id, :amount, :description, :payment_at)
      end

      def set_expense
        @expense = Expense.find(params[:id])
      end
    end
  end
end
