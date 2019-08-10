class ApplicationController < ActionController::API
  respond_to :json

  private

  def render_error(status, resource = nil)
    render status: status,
           json: (resource ? { error: resource } : nil)
  end

  def respond_with_validation_error(model, errors = nil)
    render_error :unprocessable_entity,
                 name: "Validation failed",
                 messages: (errors || model.errors)
  end
end
