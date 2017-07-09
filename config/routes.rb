Rails.application.routes.draw do
  # Only for authentication
  post 'user_token' => 'user_token#create'

  # Resources
  get 'accounts/balances'
  post 'accounts/transfer'
  resources :accounts do
    resources :transactions
    get 'edit'
    post 'correct'
  end

  resources :budgets do
    resources :periods
    resources :transactions
    get 'edit'
  end

  resources :currencies do
    resources :budgets
    resources :accounts
    get 'edit'
  end

  resources :transaction_categories do
    resources :transactions
    get 'edit'
  end

  resources :targets do
    resources :transactions
    get 'edit'
  end

  resources :periods do
    resources :transactions
    get 'edit'
    get 'expenses'
    post 'close'
    post 'cycle'
    post 'reopen'
  end

  resources :transactions do
    get 'edit'
  end

  get 'overview', controller: 'static_pages'
  match '*path', to: 'catch_all#index', via: :all
end
