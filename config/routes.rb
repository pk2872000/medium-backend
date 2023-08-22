Rails.application.routes.draw do

  # get 'payments/index', to: 'payments#index'
  
  namespace :api do
    namespace :v1 do
      devise_for :users, path: 'auth', controllers: {
        registrations: 'api/v1/registrations', only: [:create]
      }

     
      post 'auth/login', to: 'authentication#login'
      delete 'auth/logout', to: 'authentication#logout'
      get 'search', to: 'posts#search'


      resource :profile, only: [:show, :update] do
        collection do
          get 'myPosts'
        end
      end

      resources :posts, except: [:new, :edit] do
        member do
          post 'like'
          delete 'unlike'
          post 'save_for_later'
          delete 'unsave'
          get 'stats'
          get 'comments_get'
          post 'comments_post'
          get 'more_posts_by_similar_author'
          get 'show_by_reducing_attempt'
          post 'add_to_list'
          delete 'delete_post_from_list'
        end

        collection do
          get 'top_posts'
          get 'recommended_posts'
          get 'get_all_lists'
          
        end

        resources :comments, only: [:create]
      end

      resources :comments, except: [:new, :edit, :create] do
        member do
          post 'like'
          delete 'unlike'
        end
      end


      resources :revisions, only: [:index] do
        member do
          post 'restore'
        end
        collection do
          get 'revisions_of_current_user'
        end
      end


      resources :users, only: [:show, :index] do
        member do
          post 'follow'
          delete 'unfollow'
          get 'posts'
          get 'remaining_attempts'
        end
        collection do
          get 'myProfile'
          get 'remaining_attempts'
          get 'get_all_followers'
        end
      end

      resources :subscriptions, only: [:index] do
        member do
          post 'subscribe', to: 'subscriptions#create'
        end
        collection do
          get 'my_subscribtions', to: 'subscriptions#my_subscribtions'
        end
      end

      post 'payments', to: 'payments#create'
      post 'verify_payment', to: 'payments#verify_payment'
      

      
    end
  end
end
