module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user
      before_action :set_user, only: [:show, :follow, :unfollow, :posts]


      def stats
        { followers: @user.followers.count, followings: @user.followings.count }
      end


      def index
        @users = User.all
        render json: @users
      end

      def show
        render json: { user: @user, stats: stats }
      end
      
    
    



      def remaining_attempts
        token = request.headers['Authorization'] 
        @current_user ||= User.find_by(auth_token: token)

        @remaining_attempt = RemainingAttempt.find_by(user_id: @current_user.id)
        if @remaining_attempt
          render json: @remaining_attempt
        else
          render json: {msg: "you dont have any subscription or attempts"}
        end
      end


      def get_all_followers
        @all_followers = Follower.all.where(follower_id: @current_user.id)
        if @all_followers
          render json: @all_followers
        else 
          render json: {msg: "you have not followed anyone"}
        end
      end


      
      def follow

        token = request.headers['Authorization']
        @current_user ||= User.find_by(auth_token: token)

        user_to_follow = User.find(params[:id])
        
        # Check if the current_user is trying to follow themselves
        if @current_user == user_to_follow
          render json: { error: 'You cannot follow yourself' }, status: :unprocessable_entity
          return
        end
      
        # Check if the current_user has already followed the user_to_follow
        existing_relation = Follower.find_by(follower: @current_user, followed: user_to_follow)
        if existing_relation
          render json: { error: 'You are already following this user' }, status: :unprocessable_entity
          return
        end
      
        # Create the follow relationship
        follow_relation = Follower.new(follower: @current_user, followed: user_to_follow)
      
        if follow_relation.save
          render json: { message: 'Followed successfully..' + @current_user.id.to_s + " -> " + params[:id] , }
        else
          render json: { errors: follow_relation.errors.full_messages }, status: :unprocessable_entity
        end
      end
      

      def unfollow
        token = request.headers['Authorization'] 
        @current_user ||= User.find_by(auth_token: token)

        existed_record = Follower.all.where(follower_id: @current_user.id, followed_id: params[:id])

        if !existed_record.exists?
          render json: {msg: 'You are not following this user'}
        else
          existed_record.destroy_all
          render json: {msg: 'You have unfollowed the user with user_id=' + params[:id]}
        end
      end



      def posts
        @posts = @user.posts
        render json: @posts
      end

      

      private

      def set_user
        @user = 
        if params[:id].present?
          User.find_by(id: params[:id])
        else
          @current_user
        end
      end
    end
  end
end
