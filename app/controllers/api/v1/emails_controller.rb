module Api
  module V1
    class EmailsController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_email, only: [:show]

      # GET /api/v1/emails
      def index
        # for staff show only their emails, for admin show all emails
        if current_user.user_role == "staff"
          @emails = current_user.emails.all
        else
          @emails = Email.all
        end

        render json: @emails
      end

      # GET /api/v1/emails/1
      def show
        # Allow users to see emails assigned to them or admin can see all emails
        if @email.user_id == current_user.id || current_user.user_role == "admin"
          params = {
            "from" => @email.from,
            "status" => @email.status,
            "subject" => @email.subject,
            "to" => @email.to,
            "id" => @email.id,
            "assigned_to" => @email.user ? @email.user.email : nil
          }
          render json: { data: params, replies: @email.replies }, status: :ok
        else
          render json: { success: false }, status: :forbidden
        end
      end

      # POST /api/v1/emails
      def create
        # allow only admin to create emails add pending status before saving
        if current_user.user_role === "admin"
          params = email_params
          params["status"] = "pending"
          # params["user_id"] = current_user.id
          @email = Email.new(params)

          if @email.save
            render json: @email, status: :created
          else
            render json: @email.errors, status: :unprocessable_entity
          end
        else
          render json: { success: false, message: 'Action not permitted' }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/emails/1
      # def update
      #   if @email.update(email_params)
      #     render json: @email
      #   else
      #     render json: @email.errors, status: :unprocessable_entity
      #   end
      # end

      # DELETE /api/v1/emails/1
      # def destroy
      #   @email.destroy
      # end

      # assign a email to a different user
      def assign_email_to_user
        email_id = params["email_id"]
        user_id = params["user_id"]

        # allow only admin to change email's owner
        if current_user.user_role == "admin" &&
          Email.exists?(email_id) && User.exists?(user_id)
            @email = Email.find(email_id)
            @email.user_id = user_id
            @email.save
        else
          render json: { success: false }, status: :unprocessable_entity
        end

        render json: { success: true }
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_email
          @email = Email.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def email_params
          params.require(:email).permit(:from, :to, :subject, :text, :status, :user_id)
        end
    end
  end
end
