Rails.application.routes.draw do
  get 'relationships/follower'
  get 'relationships/followed'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users

  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  get 'tagsearches/search', to: 'tagsearches#search'

  resources :chats, only: [:show, :create]

  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
  end

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships,  only: [:create, :destroy]
    get "search", to: "users#search"
    get :follows, on: :member
    get :followers, on: :member
  end

  end




  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
