module Api
  module V1
    class UsersController < ApiApplicationController
      skip_before_action :authorized, only: [:create]

      def create
        user = User.create!(user_params)
        auth_token = Auth::AuthenticateUser.new(user.email, user.password).call
        render json: {
          message: 'Account created successfully',
          token: auth_token,
          token_type: 'Bearer'
        }, status: :created
      end

      private

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
