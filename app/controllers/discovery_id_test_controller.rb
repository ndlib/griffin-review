class DiscoveryIdTestController < ApplicationController

  layout 'empty'

  def show
    check_admin_permission!
    records = DiscoveryApi.search_by_ids(params[:id])

    if records.size != 0
      @record = records.first.data
    else
      @record = ""
    end
  end

end
