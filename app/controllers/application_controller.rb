class ApplicationController < ActionController::API
	include JWTSessions::RailsAuthorization
	# intercept all the JWTSession Unauthorized errors and throw error from private method not_authorized
	rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

	private
		# get current_user so that its available to all the controllers via inheritance
		def current_user
			# decode the user_id from the token via the payload method
			@current_user ||= User.find(payload['user_id'])
		end

		# handle not authorized error for invalid tokens
		def not_authorized
			render json: { error: 'User not authorized' }, status: :unauthorized
		end
end
