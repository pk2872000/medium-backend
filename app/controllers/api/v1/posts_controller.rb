module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user, except: [:index, :show]
      before_action :set_post, only: [:show, :update, :destroy, :like, :unlike, :more_posts_by_similar_author, :save_for_later, :unsave, :stats]


      def index
      
        if params[:sort_by] == 'comments'
          @posts = Post.left_joins(:comments)
                       .group(:id)
                       .select('posts.*, COUNT(comments.id) AS comments_count')
                       .order('comments_count DESC')
        elsif params[:topic]
          @posts = Post.find_by(topic: params[:topic])
        elsif params[:sort_by] == 'likes'
          @posts = Post.left_joins(:likes)
                       .group(:id)
                       .select('posts.*, COUNT(likes.id) AS likes_count')
                       .order('likes_count DESC')
        else
          @posts = Post.all
        end

        render json: @posts

      end

      def create
        @post = @current_user.posts.build(post_params)
        @post.reading_time = ( params[:content].split.size / 60.0 ).ceil
        if @post.save
          @revision = Revision.create(
            action: "Created",
            post_id: @post.id,
            user_id: @current_user.id,
            title: params[:title],
            topic: params[:topic],
            content:  params[:content],
            status: params[:status]
          )
          if @revision.save
            render json: {post: @post, revision: @revision}, status: :created
          else
            render json: {x: @revision.errors + "okk"}, status: :unprocessable_entity
          end
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      
      def update
       
        @post = @current_user.posts.all.where(id: params[:id])
        if !@post
          render json: {msg: "no post found with provided it"}
          return
        end

        if  @post.update(post_params)
          @revision = Revision.new(
            action: "Updated",
            post_id: params[:id],
            user_id: @current_user.id,
            title: params[:title],
            topic: params[:topic],
            content:  params[:content],
            status: params[:status]
          )

          if @revision.save
            render json: {post: @post, revision: @revision}
          else
            render json: @revision.errors, status: :unprocessable_entity
          end
        else
          render json: {msg: @post.errors }, status: :unprocessable_entity
        end
      end


      
      def destroy
        @revision = Revision.new(
          action: "Deleted",
          post_id: @post.id,
          user_id: @current_user.id,
        )
        if @revision.save
          if @post.destroy
            render json: {msg: "successfully deleted", revision: @revision}
          else
            render @post.errors, status: :unprocessable_entity
          end
        else
           render @revision.errors, status: :unprocessable_entity
        end
      end





      def show_by_reducing_attempt
        token = request.headers['Authorization'] 
        @current_user ||= User.find_by(auth_token: token)

        @attempts = RemainingAttempt.find_by(user_id: @current_user.id)
        if @attempts
           @attempts.attempts -= 1
           if @attempts.attempts == 0
              @attempts.destroy
           else
            @attempts.save
           end
           @post = Post.find(params[:id])
          render json: @post
        else
          render json: {msg: "Do new subscription"}
        end
        
      end




      def comments_get
        @post = Post.find_by(id: params[:id])

        if @post.nil?
          render json: { error: "Post not found" }, status: :not_found
          return
        end

        @comments = @post.comments
        render json: @comments
      end




      def like
        @post = Post.find(params[:id])

        token = request.headers['Authorization'] 
        @current_user ||= User.find_by(auth_token: token)

        existing_vote = @post.votes.find_by(user_id: @current_user.id)
        
        if existing_vote
          existing_vote.destroy
          render json: { message: "You've unliked this post.", likes_count: @post.votes.count }, status: :ok
          return
        end

        vote = @post.votes.new(user_id: @current_user.id, post_id: params[:id])
        
        if vote.save
          total_votes = @post.votes.count
          render json: { message: 'Liked successfully.' , likes_count: total_votes}, status: :created
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end




      def comments_post

        token = request.headers['Authorization']  
        @current_user ||= User.find_by(auth_token: token)

        @post = Post.find_by(id: params[:id])
        if @post.nil?
          render json: { error: "Post not found" }, status: :not_found
          return
        end


        @comment = Comment.new(user_id: @current_user.id, post_id: params[:id], content: params[:content])

        @existing_comment = @post.comments.where(user_id: @current_user.id)

        if @existing_comment.exists?
          @existing_comment.destroy_all
        end

        if @comment.save
          render json: {msg: "added comment successfully", comment: params[:content]}
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      
      def recommended_posts
        @recommended_posts = Post.where(user_id: Follower.where(follower_id: @current_user.id)).order(created_at: :desc)
        if @recommended_posts
          render json: @recommended_posts 
        else
          render json: {msg: "there are no posts that are posted by the authors followed by you"}
        end
      end


      def add_to_list
        @post = Post.find(params[:id])
        if @post
          @record = List.create(list_name: params[:list_name], post_id: @post.id)
        else
          render json: {msg: "no post selected"}
          return
        end


        if @record.save
          render json: {msg: "added successfully", record: @record}
        else
          render json: @record.errors, state: :unprocessable_entity
        end
      end


      def top_posts
        top_posts = Post.left_joins(:likes, :comments)
                       .select('posts.*, COUNT(DISTINCT likes.id) AS total_likes, COUNT(DISTINCT comments.id) AS total_comments')
                       .group('posts.id')
                       .order('total_likes DESC, total_comments DESC')
                       .limit(10)

        render json: top_posts, status: :ok
      end



      def delete_post_from_list
        @post = Post.find(params[:id])
        if !@post
          render json: {msg: "no post exist with given id"}
          return 
        end

        @list = List.find_by(post_id: @post.id, list_name: params[:list_name])
        if @list 
          @list.destroy
          render json: {msg: "deleted successfully"}
        else
          render json: {msg: "no list found with given post id"}
        end
      end 



     

      def get_all_lists
        @lists = List.all
        if @lists 
          render json: @lists 
        else 
          render json: {msg: "no lists created"}
        end
      end

  


      def save_for_later 

        token = request.headers['Authorization'] 
        @current_user ||= User.find_by(auth_token: token)

        @post = Post.find_by(id: params[:id])
        if @post.nil?
          render json: { error: "Post not found" }, status: :not_found
          return
        end

        @existed_record = @post.saved_posts.where(user_id: @current_user.id)

        if @existed_record.exists?
          @existed_record.destroy_all
          render json: {msg: "removed from saved posts"}
        else
          @new_saved_post = SavedPost.new(user_id: @current_user.id, post_id: params[:id])
          if @new_saved_post.save
            render json: {msg: "added current post to saved_posts", saved_post: @new_saved_post}
          else 
            render json: @new_saved_post.errors,  status: unprocessable_entity
          end
        end
      end



     
      def more_posts_by_similar_author
        @posts = Post.all.where(user_id: @post.user_id)
        if @posts
          render json: @posts
        else 
          render json: {msg: "this author has no posts"}
        end
      end









      def unsave
        @current_user.saved_for_later.delete(@post)
        render json: { count: @current_user.saved_for_later.count }, status: :ok
      end





      def search
        query = params[:query]
        if query.present?
          posts = Post.where('title ILIKE ? OR content ILIKE ?', "%#{query}%", "%#{query}%")
          render json: posts
        else
          render json: { error: 'Search query parameter "query" is required.' }, status: :bad_request
        end
      end
      



      def stats
        data = { likes_count: @post.likes.count, coments_count: @post.comments.count }
        render json: data, status: :ok
      end







      private

      def set_post
        @post = Post.find(params[:id])
      end
      

      def post_params
        params.permit(:title, :content, :status, :reading_time, :topic, :avatar)
      end

      def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end

      
    end
  end
end
