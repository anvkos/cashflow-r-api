module Api
  module V1
    class ExpensesController < Api::V1::BaseController
      before_action :set_expense, only: [:update]

      def create
        @expense = current_user.expenses.create(expense_params)
        if @expense.persisted?
          render json: @expense, status: :created, adapter: :json
        else
          respond_with_validation_error(@expense)
        end
      end

      def update
        if @expense.update(expense_params)
          render json: @expense, adapter: :json
        else
          respond_with_validation_error(@expense)
        end
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
