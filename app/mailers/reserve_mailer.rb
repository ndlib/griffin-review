class ReserveMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def new_request_notifier(reserve)
    @reserve = reserve
    mail(:to => 'prader@nd.edu, jhartzler@nd.edu', :subject => "Video Digitization Request from " + @reserve.requestor_name)
  end


end
