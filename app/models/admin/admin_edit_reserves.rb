class AdminEditReserves


  def initialize(reserve)
    @reserve = reserve
  end


  def set_discovery_id(discovery_id)
    @reserve.discovery_id = discovery_id

    # if it does not have a url and the item can have a url and the discovery system has an electronic copy use it.
  end


  def set_meta_data(data)
    if data.size > 0
      @reserve.discovery_id = nil
    end


  end


  def set_resource_url(url)

  end


  def upload_pdf

  end


  private




end
