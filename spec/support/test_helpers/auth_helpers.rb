module TestHelpers
  module AuthHelpers
    def valid_token_header(user)
      token = Auth::AuthenticateUser.call(email: user.email, password: user.password).result
      authorization_header(token)
    end

    def invalid_token_header(user)
      payload = { user_id: user.id, exp: 1.hour.from_now.to_i}
      token = JWT.encode(payload, 'eyJfbGciOiJIUzI1NiJ9.eyJ1c2VyX2lqIjo0LCJl', 'HS256')
      authorization_header(token)
    end

    def expired_token_header(user)
      payload = { user_id: user.id, exp: 1.hour.ago.to_i}
      token = JWT.encode(payload, Rails.application.credentials.dig(:jwt, :secret_key), 'HS256')
      authorization_header(token)
    end

    private

    def authorization_header(token)
      { "Authorization" => "Bearer #{token}" }
    end
  end
end
