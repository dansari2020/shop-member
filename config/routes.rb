Rails.application.routes.draw do
  get 'explore/:api' => 'api#explore', :as => :explore_api

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    # omniauth_callbacks: 'users/omniauth_callbacks'
  } do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  root to: 'home#index'
  match "users/auth/doorkeeper/callback" => "users/omniauth_callbacks#doorkeeper", as: :oauth_callback, via: [:get, :post]
  match "users/auth/doorkeeper" => "users/omniauth_callbacks#user_authorize", as: :user_authorize, via: [:get, :post]
end
