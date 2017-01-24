class ReportProblemsController < ApplicationController
  def new
  end

  def create
    m = Masquerade.new(self)
    user = m.masquerading? ? m.original_user : current_user

    SpiceworksMailer.create_ticket(user, params[:path], params[:comments]).deliver_now
  end
end
