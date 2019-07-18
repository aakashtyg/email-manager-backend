Rails.application.routes.draw do

	# namespace emails and replies so that the url can be /api/v1/
	namespace :api do
		namespace :v1 do
      resources :emails do
        member do
          post 'assign_email_to_user'
        end
      end
      resources :replies
  	end
  end

  # just to check if everything is working
  root to: "home#index"

  post "refresh", controller: :refresh, action: :create
  post "login", controller: :login, action: :create
  post "signup", controller: :signup, action: :create
  delete "logout", controller: :login, action: :destroy
  get "users", controller: :users, action: :index
	get "update_emails_in_db", controller: :home, action: :update_emails_in_db
end
