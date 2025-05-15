Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'books#index'
  post 'books/upload', to: 'books#upload'
  post 'books/upload_api', to: 'books#upload_to_api'
  get 'download_audio', to: 'books#download_audio'
  get '/audio', to: 'books#audio'
  get '/player_partial', to: 'books#player_partial'

  # API namespace
  namespace :api do
    namespace :v1 do
      post 'upload_pdf', to: 'books#upload_pdf'
      get 'retrieve_text/:id', to: 'books#retrieve_text'
      get 'download_audio/:id', to: 'books#download_audio'
    end
  end
end
