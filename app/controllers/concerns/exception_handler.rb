module ExceptionHandler extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError do |e|
      render json: { error: { code: 401, message: e.message } }, status: :unauthorized
    end

    rescue_from ExceptionHandler::MissingToken do |e|
      render json: { error: { code: 401, message: e.message } }, status: :unauthorized
    end

    rescue_from ExceptionHandler::InvalidToken do |e|
      render json: { error: { code: 401, message: e.message } }, status: :unauthorized
    end

    rescue_from ExceptionHandler::ExpiredSignature do |e|
      render json: { error: { code: 401, message: e.message } }, status: :unauthorized
    end
  end
end
