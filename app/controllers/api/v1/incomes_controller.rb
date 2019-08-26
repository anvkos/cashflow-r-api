module Api
  module V1
    class IncomesController < Api::V1::BaseController
      before_action :set_income, only: [:update]

      def create
        service = CreateIncomeService.new
        service.on(:income_created) { |income| render json: income, status: :created, adapter: :json }
        service.on(:income_error) { |income| respond_with_validation_error(income) }
        @income = service.call(current_user, income_params)
      end

      def update
        authorize @income
        service = UpdateIncomeService.new
        service.on(:income_updated) { |income| render json: income, adapter: :json }
        service.on(:income_error) { |income| respond_with_validation_error(income) }
        @income = service.call(@income, income_params)
      end

      private

      def income_params
        params.require(:income).permit(:category_id, :account_id, :amount, :description, :payment_at)
      end

      def set_income
        @income = Income.find(params[:id])
      end
    end
  end
end
