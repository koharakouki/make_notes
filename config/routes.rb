class ErrorAvoid
  def initialize
    @url = "/attachments"
  end

  def matches?(request)
    @url.include?(request.url)
  end
end


Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'devise/admins/sessions',
  }

  devise_for :users, controllers: {
    sessions: 'devise/users/sessions',
    registrations: 'devise/users/registrations',
    passwords: 'devise/users/passwords',
    omniauth_callbacks: 'devise/users/omniauth_callbacks',
  }

  root 'home#top'
  get '/home/help', to: 'home#help'
  resources :users, only: [:edit, :update, :destroy, :index] do
    resources :genres, only: [:index, :create, :destroy]
    resources :lists, only: [:show, :create, :edit, :update, :destroy]
    member do
      get :following, :followers, :calendar
    end
  end
  resources :notifications, only: :index
  resources :relationships, only: [:create, :destroy]
  get '/search', to: 'search#search'
  resources :articles, only: [:new, :create, :show, :index, :destroy] do
    resource :article_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end

  get '/users/:user_id/want', to: 'lists#want', as: 'want'
  get '/users/:user_id/done', to: 'lists#done', as: 'done'

  # 管理者のルーティング
  namespace :admin do
    resources :users, only: [:index, :destroy]
    root 'users#chart'
    resources :articles, only: [:index, :show, :destroy]
  end

  # 開発環境でletter_opener_webを使うための処理
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  # 例外のためのルーティング
  unless request.url.include? 'attachments'
  get '*path', to: 'application#render_404'
  do#, constraints: ErrorAvoid.new
  # get '*not_found', to: 'application#routing_error', constraints: ErrorAvoid.new
  # post '*not_found', to: 'application#routing_error'
end

