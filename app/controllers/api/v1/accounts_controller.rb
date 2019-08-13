module Api
  module V1
    class AccountsController < Api::V1::BaseController
      def index
        @accounts = current_user.accounts
        render json: @accounts, each_serializer: AccountSerializer, adapter: :json
      end

      def create
        @account = current_user.accounts.create(account_params)
        if @account.persisted?
          render json: @account, status: :created, adapter: :json
        else
          respond_with_validation_error(@account)
        end
      end

      private

      def account_params
        params.require(:account).permit(:currency_id, :name, :amount)
      end
    end
  end
end
