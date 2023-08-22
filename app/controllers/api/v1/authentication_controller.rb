module Api
  module V1
    class AuthenticationController < ApplicationController
      before_action :authenticate_user, only: :logout
      respond_to :json

      def login
        user = User.find_by(email: params[:email])

        if user&.valid_password?(params[:password])
          render json: { jwt: JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base) }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end 
      
      def logout
        sign_out(@current_user)
        render json: { message: 'Logged out successfully' }
      end
    end
  end
end
