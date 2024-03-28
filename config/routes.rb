Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    resources :users, only: [:create]
    resources :exams, only: [:create]
    resources :colleges, only: [:create]
    resources :exam_windows, only: [:create]
  end
end
