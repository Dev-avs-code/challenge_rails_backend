module Api
  module V1
    class AuthController < ApiApplicationController
      skip_before_action :authorized, only: [:login]

      def login
        @token = Auth::AuthenticateUser.new(login_params[:email], login_params[:password]).call
        render json: { message: 'Login successful', token: @token, token_type: 'Bearer' }, status: :accepted
      end

      private

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
