Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "omniauth_callbacks#callback"

  resources :participations, only: [:update, :destroy]

  namespace :users do
    resources :rooms do
      resources :review_requests, only: [:new, :create], controller: "rooms/review_requests"
    end
    delete "/sign_out", to: "sessions#destroy"
    patch "/sync_repos", to: "repositories#update"
    patch "/sync_pulls/:id", to: "pull_requests#update", as: "sync_pulls"
  end

  resources :users, param: :name, path: "/", only: [] do
    get "/repositories", to: "users/repositories#index"
    resources :repositories, param: :name, path: "/", only: [:show], controller: "users/repositories" do
      resources :pull_requests, only: [:show], controller: "users/pull_requests"
    end
  end

  resources :pull_requests, only: [] do
    resources :review_requests, only: [:new, :create], controller: "users/review_requests"
  end
end
