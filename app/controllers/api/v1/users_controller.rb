module Api
  module V1
    class UsersController < ApiApplicationController
      skip_before_action :authorized, only: [:create]

      def create
        user = User.create!(user_params)
        auth_token = Auth::AuthenticateUser.call(email: user.email, password: user.password)
        render json: {
          data: {
            message: 'Account created successfully',
            token: auth_token.result,
            token_type: 'Bearer',
            expired_at: auth_token.expired_at,
            user: UserSerializer.new(auth_token.user)
          }
        }, status: :created
      end

      private

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
