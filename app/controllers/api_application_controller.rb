class ApiApplicationController < ActionController::API
  include ExceptionHandler

  before_action :authorized

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity

  protected

  def pagination(record)
    {
      pagination: {
        total_records: record.total_count,
        current_page: record.current_page,
        total_pages: record.total_pages,
        next_page: record.next_page,
        prev_page: record.prev_page
      }
    }
  end

  def authorized
    @current_user = (Auth::AuthorizeRequest.new(request.headers).call)[:user]
  end

  private

  def handle_unprocessable_entity(exception)
    render json: {
      error: {
        code: 422,
        message: "Validation failed",
        details: exception.record.errors.to_hash
    }
    }, status: :unprocessable_entity
  end

  def handle_not_found(exception)
    render json: {
      error: {
        code: 404,
        message: exception.message
      }
    }, status: :not_found
  end
end
