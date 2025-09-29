module Auth
  class AuthorizeRequest
    HMAC_SECRET = Rails.application.credentials.dig(:jwt, :secret_key)
    ALGORITHM = 'HS256'

    def initialize(headers = {})
      @headers = headers
    end

    def call
      {
        user: user
      }
    end

    private

    def user
      @user ||= User.find(decoded_token[:user_id]) if decoded_token
    rescue ActiveRecord::RecordNotFound
      raise ApiException::InvalidToken
    end

    def decoded_token
      @decoded_token ||= JWT.decode(header_token, HMAC_SECRET, true, { algorithm: ALGORITHM }).first
      HashWithIndifferentAccess.new @decoded_token
    rescue JWT::ExpiredSignature
      raise ApiException::ExpiredSignature
    rescue JWT::DecodeError
      raise ApiException::InvalidToken
    end


    def header_token
      return @headers['Authorization'].split(' ').last if @headers['Authorization'].present?

      raise ApiException::MissingToken
    end
  end
end
