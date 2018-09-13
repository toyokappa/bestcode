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

    namespace :rooms, path: "rooms/:room_id" do
      resources :evaluations, only: [:new, :create]
    end

    resources :rooms do
      get "reopen", on: :member
      resources :chats, only: [:index]
      resources :review_requests, only: [:index]
      resource :review_request, only: [:create, :update]
    end

    resources :my_rooms, only: [] do
      get "reviewer", on: :collection
      get "reviewee", on: :collection
    end

    delete "/sign_out", to: "sessions#destroy"
    patch "/top", to: "top#update"
    patch "/sync_repos", to: "repos#update"
    get "/pulls/info", to: "pulls#info"
    get "/profiles/:name", to: "profiles#show", as: "profile"
    patch "/profiles/:name/update_heder", to: "profiles#update_header", as: "update_profile_header"
  end

  post "/hooks/pulls", to: "hooks#pulls"
  post "/hooks/state", to: "hooks#state"
  post "/markdown/preview", to: "markdown#preview"
end
