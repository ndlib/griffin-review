class ReserveUrlResourcePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def can_have_url_resource?
    return true if ['JournalReserve', 'VideoReserve', 'AudioReserve'].include?(@reserve.type)

    false
  end


  def streaming_server_redirect?
    ['VideoReserve', 'AudioReserve'].include?(@reserve.type)
  end


  def has_url_resource?
    can_have_url_resource? && @reserve.url.present?
  end


end
