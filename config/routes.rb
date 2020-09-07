Rails.application.routes.draw do
  post 'charges/charge_card'
  post 'charges/refund'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/home/:id', to: 'home#show', as: 'patient'

  root 'home#index'
end
