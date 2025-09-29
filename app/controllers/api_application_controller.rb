class ApiApplicationController < ActionController::API
  include ApiException::Handler

  before_action :authorized

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
end
