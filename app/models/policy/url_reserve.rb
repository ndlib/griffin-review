class UrlReserve


  def initialize(reserve)
    @reserve = reserve
  end


  def is_url_reserve?
    TextIsUriPolicy.uri?(@reserve.url)
  end


  def redirect_url
    if is_url_reserve?
      @reserve.url
    else
      false
    end
  end


  def file_path
    false
  end

end
