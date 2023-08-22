# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include ActionController::MimeResponds
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user
    token = request.headers['Authorization']
    if token
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
      @current_user = User.find(decoded_token[0]['user_id'])
    else
      render json: { error: 'Token is missing or invalid' }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: 'Token is missing or invalid' }, status: :unauthorized
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation])
  end
end
