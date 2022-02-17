Rails.application.routes.draw do
  devise_for :users

  root 'courses#index'

  resources :courses, only: %i[index show], shallow: true do
    member { post :own }

    resources :topics, only: %i[show] do
      resources :lessons, only: %i[show] do
        member { get :photos }
      end

      member { get :plan }
    end
  end

  resources :tests, only: :show, shallow: true do
    member do
      get :semi
      get :main
      post :start
    end
  end

  resources :test_passages, only: %i[show update] do
    member do
      get :result
      put :help
    end
  end

  # mount PgHero::Engine, at: 'pghero'

# ########################
# ADMIN PANEL 
# ########################

  namespace :admin do
    resources :courses, shallow: true do

      resources :topics, shallow: true do
        resources :lessons, except: :index do
          resources :photos, only: %i[index edit update destroy]
        end
      end
    end

    resources :tests, only: %i[show], shallow: true do

      resources :questions, except: :index do
        resources :answers, except: :index
      end
    end
  end
end
