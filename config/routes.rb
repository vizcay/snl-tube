Rails.application.routes.draw do
  root to: 'application#start'

  namespace :api, defaults: { format: :json } do
    resource :sessions, only: [:create, :destroy]
    get 'videos', to: 'videos#index'
    get 'videos/:id', to: 'videos#show'
  end

  get '/', to: 'application#start', as: :videos
  get '/sign_in', to: 'application#start'
  get '/:id', to: 'application#start', as: :show_video
end
