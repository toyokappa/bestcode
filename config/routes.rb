Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "omniauth_callbacks#callback"

  namespace :users do
    root "top#index"

    resources :participations, only: [:update, :destroy]

    resources :repos, only: [:index, :show, :new, :create] do
      resources :pulls, only: [:show]
    end

    namespace :rooms do
      resources :review_requests, path: "/:room_id/review_requests", only: [:show, :new, :create, :edit, :update]
    end

    namespace :pulls do
      resources :review_requests, path: "/:pull_id/review_requests", only: [:new, :create]
    end

    resources :review_comments, only: [:create, :update, :destroy]

    resources :rooms do
      get "reopen", on: :member
    end

    resources :my_rooms, only: [:index]

    delete "/sign_out", to: "sessions#destroy"
    patch "/top", to: "top#update"
    patch "/sync_repos", to: "repos#update"
    get "/pulls/info", to: "pulls#info"
    get "/profiles/:name", to: "profiles#show", as: "profile"
    patch "/profiles/:name/update_heder", to: "profiles#update_header", as: "update_profile_header"
  end

  post "/hooks/pulls", to: "hooks#pulls"
end
