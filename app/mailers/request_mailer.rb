class RequestMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def media_admin_request_notify(request)
    @requester = request.user
    @semester = request.semester
    @request = request

    media_admins = User.joins(:roles).where('roles.name' => 'Media Admin')

    unless media_admins.blank?
      media_admins.each do |media_admin|
        mail(:to => media_admin.email, :subject => "Video Digitization Request from " + @requester.display_name, :content_type => "multipart/alternative")
      end
    else
      self.message.perform_deliveries = false
    end

  end
end
