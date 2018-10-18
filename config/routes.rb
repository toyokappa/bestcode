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
    resources :rooms do
      get "reopen", on: :member
      resources :chats, only: [:index]
      resources :review_requests, only: [:index]
      resource :review_request, only: [:create, :update]
      resources :evaluations, only: [:new, :create, :edit, :update, :destroy] do
        delete "skip", on: :collection
      end
    end
    resources :my_rooms, only: [] do
      get "reviewer", on: :collection
      get "reviewee", on: :collection
    end
    resource :notice, only: [:create]

    delete "/sign_out", to: "sessions#destroy"
    patch "/top", to: "top#update"
    patch "/sync_repos", to: "repos#update"
    get "/pulls/info", to: "pulls#info"
    get "/profiles/:name", to: "profiles#show", as: "profile"
    patch "/profiles/update_heder", to: "profiles#update_header", as: "update_profile_header"
    patch "/profiles/sync_contributions", to: "profiles#sync_contributions", as: "sync_contributions"
  end

  get "/terms", to: "static#terms", as: "terms"
  get "/privacy_policy", to: "static#privacy_policy", as: "privacy_policy"
  get "/faq", to: "faq#index", as: "faq"
  post "/hooks/pulls", to: "hooks#pulls"
  post "/hooks/state", to: "hooks#state"
  post "/markdown/preview", to: "markdown#preview"
end
