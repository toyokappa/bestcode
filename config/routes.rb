Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "sessions#callback"
  delete "/sign_out", to: "sessions#destroy"

  resources :rooms
  resources :participations, only: [:update, :destroy]

  resources :users, param: :name, path: "/", only: [] do
    get "/repositories", to: "users/repositories#index"
    resources :repositories, param: :repo_name, path: "/", only: [:show], controller: "users/repositories"
  end

  namespace :users do
    patch "/sync_repos", to: "repositories#update"
  end
end
