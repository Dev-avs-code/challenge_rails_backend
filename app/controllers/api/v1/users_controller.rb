module Api
  module V1
    class UsersController < ApiApplicationController
      skip_before_action :authorized, only: [:create]

      def create
        user = User.create!(user_params)
        @token = encode_token(user_id: user.id)
        render json: {
            user: UserSerializer.new(user),
            token: @token
        }, status: :created
      end

      private

      def user_params
        params.permit(:email, :password)
      end
    end
  end
end
