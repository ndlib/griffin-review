class RequestsMessageController  < ApplicationController

    def create
      puts "DEBUG REQUEST MESSAGE CONTROLLER MESSAGE"
      puts session[:netid]
      puts current_user
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
      params.require(:add_message).permit(:content, :request_id)
    end
  
  end