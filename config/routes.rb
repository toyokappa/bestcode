Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "omniauth_callbacks#callback"

  namespace :users do
    resources :participations, only: [:update, :destroy]
    resources :rooms do
      resources :review_requests, only: [:new, :create], controller: "rooms/review_requests"
    end
    resources :review_requests, path: "/pulls/:pull_id/", only: [:new, :create]
    delete "/sign_out", to: "sessions#destroy"
    get "/:user_name/repositories", to: "repositories#index", as: "repositories"
    get "/:user_name/:repo_name", to: "repositories#show", as: "repository"
    get "/:user_name/:repo_name/pulls/:pull_id", to: "pull_requests#show", as: "pull_request"
    patch "/sync_repos", to: "repositories#update"
    patch "/sync_pulls/:repo_id", to: "pull_requests#update", as: "sync_pulls"
  end
end
