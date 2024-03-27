Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'books#index'
  post 'books/upload', to: 'books#upload'
  get 'download_audio', to: 'books#download_audio'
  get '/audio', to: 'books#audio'
  get '/player_partial', to: 'books#player_partial'
end
