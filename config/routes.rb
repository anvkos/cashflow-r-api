Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :categories
      resources :currencies
      resources :accounts
      resources :expenses
      resources :incomes
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
