class SemesterMailer < ActionMailer::Base
  default :from => "reserves-system@nd.edu"

  def semester_notify
    mail(:to => Rails.configuration.admin_list, :subject => "Semester Alert")
  end

end
