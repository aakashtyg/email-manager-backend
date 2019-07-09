class LoginController < ApplicationController
	# protect only destroy method, as it will be called for logged in users only
	before_action :authorize_access_request!, only: [:destroy]
	rescue_from ActiveRecord::RecordNotFound, with: :not_found

	def create
		user = User.find_by!(email: params[:email])

		# use bcrypt's authenticate method to authenticate user
		if user.authenticate(params[:password])
			# create payload from which the tokens can be created
			payload = { user_id: user.id }

			# create a session
			# refresh_by_access_allowed: Default is false. It links access
			# and refresh tokens (adds refresh token ID to access payload),
			# making it possible to perform a session refresh by the last expired access token
			session = JWTSessions::Session.new(payload: payload,
																				refresh_by_access_allowed: true)
			tokens = session.login

			# set cookie with the access token
			response.set_cookie(JWTSessions.access_cookie,
													value: tokens[:access],
													httponly: true,
													secure: Rails.env.production?)
			render json: { token: tokens[:access] }
		else
			# inherited from ApplicationController
			not_authorized
		end
	end

	# log user out
	def destroy
		session = JWTSessions::Session.new(payload: payload)
		session.flush_by_access_payload
		render json: { success: true }, status: :ok
	end

	private
		def not_found
			render json: { success: false, message: 'Can not find email/password combination' }, status: :not_found
		end
end