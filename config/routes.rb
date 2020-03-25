# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :people

  root "home#index"

  resources :climbs

  resources :discipline do
    resources :sends
  end

  resources :sends
end
