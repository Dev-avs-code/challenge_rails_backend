class ApiApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_unprocessable_entity(exception)
    render json: {
      error: {
        code: 422,
        message: "Validation failed",
        details: exception.record.errors.to_hash
    }
    }, status: :unprocessable_entity
  end

  def render_not_found(exception)
    render json: {
      error: {
        code: 404,
        message: exception.message
      }
    }, status: :not_found
  end
end
