class SakaiIntegratorController < ApplicationController
  protect_from_forgery :except => :sakai_redirect


  def sakai_redirect
    course = SakaiIntegrator.call(params[:context_id], current_user.username)
    if course
      redirect_to '/sakai' + course_reserves_path(course.id)
    else
      redirect_to '/sakai/courses'
    end
  end

  def test

  end

  private

end
