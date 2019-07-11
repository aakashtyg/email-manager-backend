class UsersController < ApplicationController
	before_action :authorize_access_request!

  def index
  	if current_user.user_role == "admin"
	    @users = User.select(:id, :email, :name, :user_role).all

			render json: @users
	  else
	  	render json: { message: 'Operation not allowed' }, status: :not_acceptable
  	end
  end
end