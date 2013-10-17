class DocumentationAdminController < ApplicationController


  def index
    check_admin_or_admin_masquerading_permission!
  end


end
