module Api
  module V1
    class ExpensesController < Api::V1::BaseController
      before_action :set_expense, only: [:update]

      def index
        @expenses = current_user.expenses.where(payment_at: search_params[:start_date].to_date..search_params[:end_date].to_date)
        render json: @expenses, each_serializer: ExpenseSerializer, adapter: :json
      end

      def create
        service = CreateExpenseService.new
        service.on(:expense_created) { |expense| render json: expense, status: :created, adapter: :json }
        service.on(:expense_error) { |expense| respond_with_validation_error(expense) }
        @expense = service.call(current_user, expense_params)
      end

      def update
        authorize @expense
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

      def search_params
        params[:start_date] = Time.now.beginning_of_month.to_s unless params[:start_date].present?
        params[:end_date] = Time.now.end_of_month.to_s unless params[:end_date].present?
        params.permit(:start_date, :end_date)
      end
    end
  end
end
