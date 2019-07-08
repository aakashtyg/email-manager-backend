Rails.application.routes.draw do

	# namespace emails so that the url can be /api/v1/
	namespace :api do
		namespace :v1 do
  		resources :emails
  	end
  end

  # just to check if everything is working
  root to: "home#index"

  post "refresh", controller: :refresh, action: :create
  post "login", controller: :login, action: :create
  post "signup", controller: :signup, action: :create
  delete "logout", controller: :login, action: :destroy
end
