module Api
  module V1
    class CategoriesController < Api::V1::BaseController
      before_action :set_category, only: [:update]

      def index
        @categories = Category.all
        render json: @categories, each_serializer: CategorySerializer, adapter: :json
      end

      def create
        @category = Category.create(category_params)
        if @category.persisted?
          render json: @category, status: :created, adapter: :json
        else
          respond_with_validation_error(@category)
        end
      end

      def update
        if @category.update(category_params)
          render json: @category, adapter: :json
        else
          respond_with_validation_error(@category)
        end
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end

      def set_category
        @category = Category.find(params[:id])
      end
    end
  end
end
