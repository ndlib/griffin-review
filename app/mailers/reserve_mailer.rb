class ReserveMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def new_request_notifier(reserve)
    @reserve = reserve

    if Rails.env == 'production'
      mail(:to => determine_email_for_reserve(reserve), :subject => "Reserve Request from " + @reserve.requestor_name)
    end
  end

  def delete_request_notifier(reserve)
    @reserve = reserve

    mail(:to => 'reserves.1@nd.edu', :subject => "Reserve Deleted")
  end

  private

  def determine_email_for_reserve(reserve)
    if ['VideoReserve'].include?(reserve.type)
      'prader@nd.edu'
    elsif ['AudioReserve'].include?(reserve.type)
      'Robert.C.Simon.41@nd.edu'
    else
      'reserves.1@nd.edu'
    end
  end

end
