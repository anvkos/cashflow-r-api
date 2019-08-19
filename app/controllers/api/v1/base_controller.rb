module Api
  module V1
    class BaseController < ApplicationController
      include Pundit
      before_action :authenticate_user!
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def user_not_authorized
        render_error(:forbidden, message: 'This action is unauthorized.')
      end

      def render_error(status, resource = nil)
        render status: status,
               json: (resource || { message: "error" })
      end

      def respond_with_validation_error(model, errors = nil)
        render_error :unprocessable_entity,
                     message: "Validation failed",
                     errors: (errors || model.errors)
      end
    end
  end
end
