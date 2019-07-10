class RefreshController < ApplicationController
	before_action :authorize_refresh_by_access_request!

	# refresh the access token using the expired access token
  def create
    # refresh_by_access_allowed: Default is false. It links access and
    # refresh tokens (adds refresh token ID to access payload), making it possible to perform a session refresh by the last expired access token
    # claimless_payload => a decoded token's payload without claims validation: used for checking data of an expired token
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_payload
    # set cookie
    response.set_cookie(JWTSessions.access_cookie,
                        value: tokens[:access],
                        httponly: true,
                        secure: Rails.env.production?)
	render json: { token: tokens[:access] }, status: :ok
  end
end