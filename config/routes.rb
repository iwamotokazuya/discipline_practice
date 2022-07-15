Rails.application.routes.draw do
  root 'tops#top'
  get 'privacy', to: 'tops#privacy'
  get 'terms', to: 'tops#terms'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :results, only: %i[show create] do
    member do
      get 'loginresults'
      get 'likeresults'
    end
    collection do
      get :likes
    end
  end

  resources :ranks, only: %i[index] do
    member do
      get 'record'
      get 'login_record'
    end
  end

  resources :likes, only: %i[create destroy]
  resources :diaries

  resources :users do
    resources :attachments, controller: 'users/attachments', only: %i[destroy]
  end
end
