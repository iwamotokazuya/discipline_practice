Rails.application.routes.draw do
  root 'tops#top'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :results, only: %i[show create] do
    member do
      get 'loginresults'
    end
  end
  resources :loginresults, only: %i[show create]

  resources :records, only: %i[new] do
    collection do
      get 'login_new'
    end
  end

  resources :users do
    resources :attachments, controller: 'users/attachments', only: %i[destroy]
  end

  resources :diaries
end
