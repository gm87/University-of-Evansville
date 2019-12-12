Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  get 'athletes/new'
  get 'welcome/index'
  get '/login', to: 'sessions#new'
  get '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get 'data/index'
  get 'data/fmorning_data'
  get 'data/factivity_data'
  get 'team/:team', to: 'athletes#index', as: "team"


  resources :athletes do
    collection do
      get 'remove_all'
    end
  end
#  resources :teams

  resources :forms
  resources :admin
  resources :users
  resources :fmorning do
    collection do
      get 'remove_all'
    end
  end
  resources :factivity do
    collection do
      get 'remove_all'
    end
  end
  resources :data

  root 'welcome#index'
end
