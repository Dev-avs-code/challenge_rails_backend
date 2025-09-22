module Auth
  class AuthenticateUser
    ALGORITHM = 'HS256'
    EXP_TOKEN = 1.hours.from_now
    HMAC_SECRET = Rails.application.credentials.dig(:jwt, :secret_key)

    def initialize(email, password)
      @email = email || nil
      @password = password || nil
    end

    def call
      payload = { user_id: user.id, exp: EXP_TOKEN.to_i }
      JWT.encode(payload, HMAC_SECRET, ALGORITHM)
    end

    private

    def user
      user = User.find_by(email: @email)
      return user if user&.authenticate(@password)

      raise ExceptionHandler::AuthenticationError, AuthMessages.invalid_credentials
    end
  end
end
