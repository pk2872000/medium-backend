module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user
      before_action :set_profile 

      def show
        if @profile 
          render json: { profile: @profile, img: url_for(@profile.avatar) }
        elsif @profile
          render json: { profile: @profile, msg: "No avatar attached" }
        else 
          render json: {msg: "cannot find profile"}
        end
      end
      
      def myPosts
        @myposts = Post.find_by(user_id: @current_user.id)
        render json: @myposts
      end

      def update
        if @profile.update(profile_params)
          render json: { profile: @profile, img: url_for(@profile.avatar) }
        else
          render json: @profile.errors, status: :unprocessable_entity
        end
      end

      

      private

      def set_profile
        token = request.headers['Authorization']  # or however you pass/store tokens
        @current_user ||= User.find(auth_token: token)

        @profile = @current_user.profile
      end

      def profile_params
        params.permit(:first_name, :last_name, :age, :gender, :avatar, :address)
      end

      

      
    end
  end
end
