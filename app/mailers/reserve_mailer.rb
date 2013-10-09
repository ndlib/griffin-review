class ReserveMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def new_request_notifier(reserve)
    @reserve = reserve

    if Rails.env == 'production'
      mail(:to => 'prader@nd.edu', :subject => "Video Digitization Request from " + @reserve.requestor_name)
    end
  end


end
