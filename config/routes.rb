Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:destroy, :show]
  end
  scope module: :public do
      devise_for :users
    root to: "homes#top"
    resources :post_images do
      resources :comments, only: [:create, :destroy]
    end
    get 'about' => 'homes#about', as: 'about'
    resources :users, only: [:show, :edit, :update, :destroy]
    get "search" => "searches#search"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
