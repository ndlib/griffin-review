class SakaiIntegratorController < ApplicationController
  include GetCourse

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!

  def sakai_redirect
    begin
      course_id = get_course_id(params[:context_id], params[:lis_person_sourcedid])
      if !course_id.blank?
        redirect_to '/sakai' + course_reserves_path(:course_id => course_id)
      else
        raise_404("Sakai user could not be matched to course via context id")
      end
    rescue Exception => e
      log_error(e)
      redirect_to '/sakai/courses'
    end
  end

  private


  def get_course_id(context_id, sakai_user)
    course_id = sakai_cache(context_id, sakai_user)
    if course_id.blank?
      course_id = sakai_callback(context_id, sakai_user) 
    end
    course_id
  end


  def sakai_cache(context_id, sakai_user)
    context_record = SakaiContextCache.where("context_id = ? AND user_id = ?", context_id, sakai_user).first
    course_id = nil
    unless context_record.blank?
      course = get_course(context_record.course_id)
      if course.enrollment_netids.include?(sakai_user)
        course_id = context_record.course_id
      elsif course.instructor_netids.include?(sakai_user)
        course_id = context_record.course_id
      end
      course_id
    end
  end


  def sakai_callback(context_id, sakai_user)
      si = SakaiIntegrator.new(self)
      si.site_id = context_id
      si.sakai_user = sakai_user
      external_site_id = si.get_site_property('externalSiteId')
      course_id, term = si.translate_external_site_id(external_site_id)
      cache_sakai_context(context_id, course_id, external_site_id, sakai_user, term)
      course_id
  end

  def cache_sakai_context(context_id, course_id, external_site_id, sakai_user, term)
    scc = SakaiContextCache.new context_id: context_id, course_id: course_id, external_id: external_site_id, user_id: sakai_user, term: term
    if scc.valid?
      scc.save!
    end
  end

end
