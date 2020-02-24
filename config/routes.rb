Rails.application.routes.draw do
  root "home#index"

  resources :discipline do
    resources :sends
  end

  resources :sends
end
