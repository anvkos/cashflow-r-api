module Api
  module V1
    class AccountsController < Api::V1::BaseController
      def index
        @accounts = current_user.accounts
        render json: @accounts, each_serializer: AccountSerializer, adapter: :json
      end
    end
  end
end
