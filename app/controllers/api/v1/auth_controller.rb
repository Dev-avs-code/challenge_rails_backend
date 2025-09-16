module Api
  module V1
    class AuthController < ApiApplicationController
      skip_before_action :authorized, only: [:login]

      def login
        @user = User.find_by!(email: login_params[:email])
        if @user.authenticate(login_params[:password])
          @token = encode_token(user_id: @user.id)
          render json: {
            user: UserSerializer.new(@user),
            token: @token
          }, status: :accepted
        else
          render json: {message: 'Invalid credentials'}, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
