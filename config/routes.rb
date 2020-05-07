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
    resources :lists, only: [:show, :index, :create, :edit, :update, :destroy]
    member do
      get :show_follow
      get :calendar
    end
  end
  resources :relationships, only: [:create, :destroy]
  get '/search', to: 'search#search'
  resources :articles, only: [:new, :create, :show, :index] do
    resource :article_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
end
