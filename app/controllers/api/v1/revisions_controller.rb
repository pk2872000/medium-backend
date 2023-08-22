module Api
    module V1

        class RevisionsController < ApplicationController
            before_action :authenticate_user
        
            def index
                render json: Revision.all
            end
        
            def revisions_of_current_user
                token = request.headers['Authorization'] 
                @current_user ||= User.find_by(auth_token: token)

                @revisions= Revision.find_by(user_id: @current_user.id)
                render json: @revisions, status: :ok
            end
        
            def restore
                @revision= current_user.revisions.find(params[:id])
                @post = Post.find_by(post_id: @revision.post_id)
                if @post.update(title: @revision.title, topic: @revision.topic, content:@revision.content, status: @revision.status)
                  render json: { post: @post, message:'created successfully'}, status: :created
                else
                  render json: { message:'not created'}, status: :unprocessable_entity
                end
            end
        
        
        end

        
    end
end