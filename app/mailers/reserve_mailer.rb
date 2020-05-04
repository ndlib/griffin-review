class ReserveMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def new_request_notifier(reserve)
    @reserve = reserve

    if Rails.env == 'production'
      mail(:to => determine_email_for_reserve(reserve.type), :subject => "Reserve Request from " + @reserve.requestor_name)
    end
  end

  def delete_request_notifier(reserve)
    @reserve = reserve

    mail(:to => 'reserves.1@nd.edu', :subject => "Reserve Deleted")
  end

  def published_request_notifier(email_info)
    email_info.each do |key, value|
      @notify = value
      @notify['reserve_contact'] = determine_email_for_reserve('VideoReserve')
      email_with_name = %("#{@notify['display_name']}" <#{@notify['email']}>)
      mail(to: email_with_name,
      content_type: "text/html",
      subject: 'Video Reserves Notification')
    end
  end

  private

  def determine_email_for_reserve(reserve_type)
    if ['VideoReserve'].include?(reserve_type)
      'prader@nd.edu'
    elsif ['AudioReserve'].include?(reserve_type)
      'tgillasp@nd.edu'
    else
      'reserves.1@nd.edu'
    end
  end

end
