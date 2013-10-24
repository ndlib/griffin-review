class SpiceworksMailer < ActionMailer::Base

  def create_ticket(current_user, path, comment)
    @comment = comment
    @path = path
    @current_user = current_user

    mail(:to => library@nd.edu, :from => current_user.email, :subject => "Reserves Problem")
  end

end
