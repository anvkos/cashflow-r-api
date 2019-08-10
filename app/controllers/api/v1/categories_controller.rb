module Api
  module V1
    class CategoriesController < Api::V1::BaseController
      def index
        @categories = Category.all
        render json: @categories, each_serializer: CategorySerializer, adapter: :json
      end
    end
  end
end
