Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: {
  	sessions:      'devise/users/sessions',
  	registrations: 'devise/users/registrations',
  	passwords:     'devise/users/passwords'
  }
  root 'home#top'
  get 'home/about'
  # urlの(:id)を(:name)に変更
  resources :users, param: :name, only: [:edit, :update, :index]
end
