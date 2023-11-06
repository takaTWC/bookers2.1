Rails.application.routes.draw do
  root :to =>"homes#top"
  devise_for :users
  get "home/about"=>"homes#about"
  get "search" => "searches#search"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :following, :follower
    end
    resource :relationships, only: [:create, :destroy]
  end


end
