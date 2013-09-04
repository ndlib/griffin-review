class SakaiIntegratorController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def sakai_redirect
    redirect_to '/sakai/courses'
    return

    if params[:context_id]
      si = SakaiIntegrator.new(self)
      si.site_id = params[:context_id]
      external_site_id = si.get_site_property('externalSiteId')
      section_group_id = si.translate_external_site_id(external_site_id)
      if !section_group_id.blank?
        redirect_to '/sakai' + course_reserves_path(:course_id => section_group_id)
      else
        raise_404
      end
    else
      raise_404
    end
  end

end
