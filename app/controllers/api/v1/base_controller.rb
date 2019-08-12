module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

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
