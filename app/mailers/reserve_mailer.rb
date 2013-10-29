class ReserveMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def new_request_notifier(reserve)
    @reserve = reserve

    if Rails.env == 'production'
      mail(:to => determine_email_for_reserve(reserve), :subject => "Reserve Request from " + @reserve.requestor_name)
    end
  end


  private
    def determine_email_for_reserve(reserve)
      if ['VideoReserve', 'AudioReserve'].include?(reserve.type)
        'prader@nd.edu'
      else
        'reserves.1@nd.edu'
      end
    end

end
