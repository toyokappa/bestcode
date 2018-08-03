Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "omniauth_callbacks#callback"

  namespace :users do
    root "top#index"
    resources :participations, only: [:update, :destroy]
    resources :rooms do
      member do
        get "reopen"
      end
    end
    resources :repos, only: [:index, :show, :new, :create] do
      resources :pulls, only: [:show]
    end
    namespace :rooms do
      resources :review_requests, path: "/:room_id/review_requests", only: [:show, :new, :create, :edit, :update]
      resources :review_comments, only: [:create]
    end
    namespace :pulls do
      resources :review_requests, path: "/:pull_id/review_requests", only: [:new, :create]
    end
    delete "/sign_out", to: "sessions#destroy"
    patch "/sync_repos", to: "repos#update"
  end

  post "/hooks/pulls", to: "hooks#pulls"
end
