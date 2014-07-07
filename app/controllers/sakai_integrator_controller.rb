class SakaiIntegratorController < ApplicationController
  include GetCourse

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!

  def sakai_redirect
    begin
      course_id = get_course_id(params[:context_id], params[:lis_person_sourcedid])
      if !course_id.blank? && user_is_part_of_course?(params[:lis_person_sourcedid], course_id)
        redirect_to '/sakai' + course_reserves_path(:course_id => course_id)
      else
        raise_404("Sakai user could not be matched to course via context id")
      end
    rescue SakaiIntegrator::TranslationError
      redirect_to '/sakai/courses'
    rescue Exception => e
      log_error(e)
      redirect_to '/sakai/courses'
    end
  end

  private

  def user_is_part_of_course?(netid, course_id)
    if course_id.blank?
      false
    else
      course = get_course(course_id)
      u = User.username(netid).first || User.new(username: netid)
      policy = UserRoleInCoursePolicy.new(course, u)

      policy.user_enrolled_in_course? || policy.user_instructs_course?
    end
  end


  def get_course_id(context_id, sakai_user)
    course_id = sakai_cache(context_id)
    if course_id.blank?
      course_id = sakai_callback(context_id, sakai_user)
    end
    course_id
  end


  def sakai_cache(context_id)
    context_record = SakaiContextCache.where("context_id = ?", context_id).first

    if context_record.blank?
      nil
    else
      context_record.course_id
    end
  end


  def sakai_callback(context_id, sakai_user)
    course_id = nil
    begin
      si = SakaiIntegrator.new(self)
      si.site_id = context_id
      si.sakai_user = sakai_user
      external_site_id = si.get_site_property('externalSiteId')
      puts "-------------------"
      puts "external site id: "
      puts external_site_id
      puts "__________________"
      course_id, term = si.translate_external_site_id(external_site_id)
      cache_sakai_context(context_id, course_id, external_site_id, sakai_user, term)
    rescue
      return
    end
    course_id
  end

  def cache_sakai_context(context_id, course_id, term)
    scc = SakaiContextCache.new context_id: context_id, course_id: course_id, term: term
    if scc.valid?
      scc.save!
    end
  end

end
