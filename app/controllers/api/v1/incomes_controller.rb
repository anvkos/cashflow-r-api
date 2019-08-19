module Api
  module V1
    class IncomesController < Api::V1::BaseController
      def create
        service = CreateIncomeService.new
        service.on(:income_created) { |income| render json: income, status: :created, adapter: :json }
        service.on(:income_error) { |income| respond_with_validation_error(income) }
        @income = service.call(current_user, income_params)
      end

      private

      def income_params
        params.require(:income).permit(:category_id, :account_id, :amount, :description, :payment_at)
      end
    end
  end
end
