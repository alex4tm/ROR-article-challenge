Rails.application.routes.draw do
  root to: 'articles#index'

  resource :articles, only: [:index, :show, :new, :create]

  get '/articles/:id', to: 'articles#show', as: 'article'
end
