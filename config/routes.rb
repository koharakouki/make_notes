Rails.application.routes.draw do
  devise_for :admins,controllers: {
    sessions: 'admins/sessions'
  }
  devise_for :users, controllers: {
  	sessions:      'devise/users/sessions',
  	registrations: 'devise/users/registrations',
  	passwords:     'devise/users/passwords'
  }
  root 'home#top'
  get 'home/about'
  resources :users, only: [:edit, :update, :index] do
    resources :genres, only: [:index, :create, :destroy]
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
end
