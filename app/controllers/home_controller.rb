require 'mail'

class HomeController < ApplicationController

	def index
		@emails = Email.all

		# sign in to ther gmail mail server with credentials
		Mail.defaults do
		  retriever_method :pop3, :address    => "pop.gmail.com",
		                          :port       => 995,
		                          :user_name  => APP_CONFIG[:gmail_username] || "test83683@gmail.com",
		                          :password   => APP_CONFIG[:gmail_password] || "",
		                          :enable_ssl => true
		end

		# get the latest mails
		emails = Mail.all
		emails.each do |email|
			if email.multipart?
				# get all require params from the mail object
				begin
					params = {
						"from" => email.from[0],
						"status" => 'pending',
						"subject" => email.subject,
						"text" => email.text_part.body.decoded.gsub(/<\/?[^>]*>/, '').gsub(/\n\n+/, "\n").gsub(/^\n|\n$/, ''),
						"to" => APP_CONFIG[:gmail_username],
						"user_id" => nil
					}

					# create a new email and save to db
					@email = Email.new(params)
					@email.save()
				rescue
					render json: { success: false }, status: :not_found and return
				end
			end
		end
		render json: @emails, status: :ok
	end
end
