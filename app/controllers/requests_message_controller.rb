class RequestsMessageController  < ApplicationController

    def create
      params[:add_message][:creator] = current_user.display_name
      message = Message.new(message_params)
      if message.save!
        flash[:success] = 'The requests note has been added.'
      else
        flash[:error] = 'Error encountered saving the note.'
      end
      redirect_to request_path(params[:add_message][:request_id])
    end

    private

    def message_params
      params.require(:add_message).permit(:creator, :content, :request_id)
    end
  
  end