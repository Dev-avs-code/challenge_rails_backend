module Api
  module V1
    class AuthController < ApiApplicationController
      skip_before_action :authorized, only: [:login]

      def login
        auth_token = Auth::AuthenticateUser.call(**login_params.to_h.symbolize_keys)
        render json: {
          data: {
            message: 'Login successful',
            token: auth_token.result,
            token_type: 'Bearer',
            expired_at: auth_token.expired_at,
            user: UserSerializer.new(auth_token.user)
          }
        }, status: :accepted
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
