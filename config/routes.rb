Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "sessions#callback"
  delete "/sign_out", to: "sessions#destroy"

  resources :rooms
  resources :participations, only: [:update, :destroy]

  resources :users, param: :name, path: "/", only: [] do
    get "/repositories", to: "users/repositories#index"
    resources :repositories, param: :name, path: "/", only: [:show], controller: "users/repositories" do
      resources :pull_requests, only: [:show], controller: "users/pull_requests"
    end
  end

  namespace :users do
    patch "/sync_repos", to: "repositories#update"
    patch "/sync_pulls/:id", to: "pull_requests#update", as: "sync_pulls"
  end
end
