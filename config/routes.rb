Easyfork::Application.routes.draw do
  resources :invite_requests
  resources :invites
  resource :user_session
  resources :apps, :member => [:name]
  #map.resources :users
  #map.resources :apps, :member => [:fork, :deploy] do |app|
  #  app.resources :files, :requirements => { :id => /.*/ }
  #  app.resources :commits, :only => [:show, :create, :index]
  #end

  get 'thanks' => "site#thanks"
  get 'join' => "users#new"
  post 'join' => "users#create"
  get 'signin' => "user_sessions#new"
  get 'signout' => "user_sessions#destroy"
  get 'login' => "users#show"

  scope ":owner_id/:name" do
    get "fork" => "apps#fork"
    get "loading" => "apps#loading"
    get "deploy" => "apps#deploy"
  
    get "commits" => "commits#index"
    post "commits" => "commits#create"
    get "commits/:index" => "commits#show"

    put "/files/:filename" => "files#update", :constraints => { :filename => /.*/ }
  end
  
  root :to => "site#home"
end
