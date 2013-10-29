class ReportProblemsController < ApplicationController

  def new
  end


  def create
    SpiceworksMailer.create_ticket(current_user, params[:path], params[:comments]).deliver
  end


end
