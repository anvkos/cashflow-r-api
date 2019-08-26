module Api
  module V1
    class IncomesController < Api::V1::BaseController
      before_action :set_income, only: [:update]

      def index
        @incomes = current_user.incomes.includes(:category, account: [:currency])
                               .latest.page(page_params[:page]).per(page_params[:per_page])
        render json: @incomes, each_serializer: IncomeSerializer, adapter: :json, meta: pagination_meta(@incomes)
      end

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

      def page_params
        {
          page: params[:page] || 1,
          per_page: params[:per_page] || 25
        }
      end

      def set_income
        @income = Income.find(params[:id])
      end
    end
  end
end
