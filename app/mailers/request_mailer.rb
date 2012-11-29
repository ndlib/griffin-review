class RequestMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def media_admin_request_notify(request)
    @requester = request.user
    @semester = request.semester
    @request = request

    media_admins = User.joins(:roles).where('roles.name' => 'Media Admin')

    unless media_admins.blank?
      media_admin_emails = []
      media_admins.each do |media_admin|
        media_admin_emails.push(media_admin.email)
      end
      unless media_admin_emails.blank?
        mail(:to => media_admin_emails, :subject => "Video Digitization Request from " + @requester.display_name)
      end
    else
      self.message.perform_deliveries = false
    end

  end

  def requester_notify(request)
    @request = request
    mail(:to => request.user.email, :subject => "Video Digitization Request Receipt")
  end
end
