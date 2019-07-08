class UsersController < ApplicationController
	before_action :authorize_access_request!

  def index
    @users = User.all

		render json: @users
  end
end