module Api
  module V1
    class CategoriesController < Api::V1::BaseController
      def index
        @categories = Category.all
        render json: @categories, each_serializer: CategorySerializer, adapter: :json
      end

      def create
        @category = Category.create(category_params)
        if @category.persisted?
          render json: @category, status: :created, adapter: :json
        else
          render json: { error: 'error create', error_messages: @category.errors.messages }, status: :unprocessable_entity
        end
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
