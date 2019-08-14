module Api
  module V1
    class CurrenciesController < BaseController
      def index
        @currencies = Currency.all
        render json: @currencies, each_serializer: CurrencySerializer, adapter: :json
      end
    end
  end
end
