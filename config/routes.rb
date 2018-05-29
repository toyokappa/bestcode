Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "omniauth_callbacks#callback"

  namespace :users do
    resources :participations, only: [:update, :destroy]
    resources :rooms
    namespace :rooms do
      resources :review_requests, path: "/:room_id/review_requests", only: [:new, :create]
    end
    namespace :pulls do
      resources :review_requests, path: "/:pull_id/review_requests", only: [:new, :create]
    end
    delete "/sign_out", to: "sessions#destroy"
    get "/:user_name/repos", to: "repos#index", as: "repos"
    get "/:user_name/:repo_name", to: "repos#show", as: "repo"
    get "/:user_name/:repo_name/pulls/:pull_id", to: "pull_requests#show", as: "pull_request"
    patch "/sync_repos", to: "repos#update"
    patch "/sync_pulls/:repo_id", to: "pull_requests#update", as: "sync_pulls"
  end
end
