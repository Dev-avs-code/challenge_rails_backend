module Auth
  class AuthenticateUser < Patterns::Service
    ALGORITHM = 'HS256'
    HMAC_SECRET = Rails.application.credentials.dig(:jwt, :secret_key)

    attr_reader :user, :expired_at

    def initialize(email: nil, password: nil)
      @email = email
      @password = password
      @expired_at = 1.hours.from_now.to_i
    end

    def call
      authenticate_user
      payload = { user_id: @user.id, exp: @expired_at }
      JWT.encode(payload, HMAC_SECRET, ALGORITHM)
    end

    private

    def authenticate_user
      @user = User.find_by(email: @email)
      return @user if @user&.authenticate(@password)

      raise ApiException::AuthenticationError
    end
  end
end
