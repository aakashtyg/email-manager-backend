module Api
  module V1    
    class RepliesController < ApplicationController
      before_action :authorize_access_request!
      # before_action :set_reply, only: [:show, :update, :destroy]

      # GET /replies
      # def index
      #   @replies = Reply.all

      #   render json: @replies
      # end

      # GET /replies/1
      # def show
      #   render json: @reply
      # end

      # POST /api/v1/replies
      def create
        params = reply_params
        @email = Email.find(reply_params["email_id"])

        # create reply if user is admin or if the user is staff to whom the email is assigned
        if current_user.user_role == "admin" || current_user.email == @email.user_id
          params["user_id"] = current_user.id
          params["from_email"] = current_user.email
          @reply = Reply.new(params)

          if @reply.save
            # change status of email also
            if @email.status != "replied"
              @email.status = "replied"
              @email.save
            end
            render json: @reply, status: :created
          else
            render json: @reply.errors, status: :unprocessable_entity
          end
        else
          render json: @reply, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /replies/1
      # def update
      #   if @reply.update(reply_params)
      #     render json: @reply
      #   else
      #     render json: @reply.errors, status: :unprocessable_entity
      #   end
      # end

      # DELETE /replies/1
      # def destroy
      #   @reply.destroy
      # end

      private
        # Use callbacks to share common setup or constraints between actions.
        # def set_reply
        #   @reply = Reply.find(params[:id])
        # end

        # Only allow a trusted parameter "white list" through.
        def reply_params
          params.require(:reply).permit(:text, :email_id)
        end
    end
  end
end
