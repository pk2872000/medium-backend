class Api::V1::SubscriptionsController < ApplicationController
  before_action :authenticate_user

  def create
    subscription = Subscription.find(params[:id])
    user = @current_user

    if user.subscriptions.include?(subscription)
      render json: { error: 'User is already subscribed to this plan.' }, status: :unprocessable_entity
    else
      user.subscriptions << subscription
      render json: { message: 'Subscription added successfully.' }
    end
  end

  def my_subscribtions
    render json: @current_user.subscriptions
  end

  def index
    render json: Subscription.all
  end

  
end
