Rails.application.routes.draw do

	# namespace emails so that the url can be /api/v1/
	namespace :api do
		namespace :v1 do
  		resources :emails
  	end
  end

  # just to check if everything is working
  root to: "home#index"
end
