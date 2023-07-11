Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/alerts', to: 'transactions#alerts'
  post '/new_transaction', to: 'transactions#new_transaction'

  resources :transactions, only: [] do
    collection do
      post :monitoring
      get :monitoring
    end
  end
end
