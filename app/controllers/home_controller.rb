class HomeController < ApplicationController
	def index
		@emails = Email.all
		render json: @emails
	end
end