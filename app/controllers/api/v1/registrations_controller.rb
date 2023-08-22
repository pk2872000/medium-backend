module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      def create
        build_resource(sign_up_params)
        resource.save
        render_resource(resource)
      end

      private

      def sign_up_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end

