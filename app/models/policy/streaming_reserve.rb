

class StreamingReserve

  def initialize(reserve)
    @reserve = reserve
  end


  def is_streaming_reserve?
    (
      ['VideoReserve', 'AudioReserve'].include?(@reserve.type) &&
      ElectronicReserve.new(@reserve).is_electronic_reserve? &&
      !streaming_service_redirect?
    )
  end


  def streaming_service_redirect?
    UrlReserve.new(@reserve).is_url_reserve?
  end


  def redirect_url
    if streaming_service_redirect?
      return @reserve.url
    else
      return false
    end
  end


  def file_path
    if is_streaming_reserve?
      return MovFileGenerator.new(@reserve).mov_file_path
    else
      return false
    end
  end
end
