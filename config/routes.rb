Rails.application.routes.draw do
  get 'diaries/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tops#top'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :results, only: %i[show create]
  resources :loginresults, only: %i[show create]

  get '/records/new' => 'records#new'
  get '/records/login_new' => 'records#login_new'

  resources :users do
    resources :attachments, controller: 'users/attachments', only: %i[destroy]
  end

  resources :diaries
end
