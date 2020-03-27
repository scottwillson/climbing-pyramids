# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :people

  root "home#index"

  resources :climbs
  resources :mountain_project_climbs
  resources :people
end
