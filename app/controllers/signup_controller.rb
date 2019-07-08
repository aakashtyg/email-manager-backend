class SignupController < ApplicationController
	# signup user
	def create
		user = User.new(user_params)

		if user.save
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
			render json: { error: user.errors.full_messages.join(' '), status: :unprocessable_identity }
		end
	end

	private
		def user_params
			params.permit(:email, :password, :password_confirmation, :name, :user_role)
		end
end