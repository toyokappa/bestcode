Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  get "/auth/:provider/callback", to: "sessions#callback"
  delete "/signout", to: "sessions#destroy"

  resources :rooms
  resources :participations, only: [:update, :destroy]
end
