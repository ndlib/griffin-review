class ElectronicReservePolicy
  attr_accessor :reserve

  def initialize(reserve)
    @reserve = reserve
  end

  def is_electronic_reserve?
    @reserve.electronic_reserve?
  end

  def electronic_resource_type
    if has_file_resource?
      "File"
    elsif has_streaming_resource?
      "Streaming Video"
    elsif has_sipx_resource?
      "Leganto ID"
    elsif has_url_resource?
      "Website Redirect"
    elsif has_media_playlist?
      "Media Playlist"
    elsif is_electronic_reserve?
      "Not Completed"
    else
      ""
    end
  end

  def resource_name
    if !has_resource?
      ""
    elsif has_file_resource?
      @reserve.pdf.original_filename
    elsif has_media_playlist?
      @reserve.type.gsub("Reserve", '')
    else
      @reserve.url
    end
  end


  def can_have_resource?
    is_electronic_reserve?
  end


  def can_have_file_resource?
    is_electronic_reserve?
  end


  def can_have_url_resource?
    is_electronic_reserve?
  end


  def can_have_streaming_resource?
    is_electronic_reserve? && ['VideoReserve', 'AudioReserve'].include?(@reserve.type)
  end

  def can_have_media_playlist?
    is_electronic_reserve? && ['VideoReserve', 'AudioReserve'].include?(@reserve.type)
  end


  def can_have_sipx_resource?
    is_electronic_reserve?
  end

  def has_resource?
    has_url_resource? || has_file_resource? || has_streaming_resource? || has_sipx_resource? || has_media_playlist?
  end

  def has_file_resource?
    (can_have_file_resource? && @reserve.pdf.present?)
  end

  def has_url_resource?
    can_have_url_resource? && !has_streaming_resource? && !has_sipx_resource? && @reserve.url.present?
  end

  def has_streaming_resource?
    can_have_streaming_resource? && @reserve.url.present? && !TextIsUriPolicy.uri?(@reserve.url)
  end

  def has_media_playlist?
    can_have_media_playlist? && @reserve.media_playlist.present?
  end

  def has_sipx_resource?
    can_have_sipx_resource? && @reserve.url.present? && @reserve.url.scan(/\D/).empty?
  end


  def sipx_url
    return false if !has_sipx_resource?

    return @reserve.url
  end


  def streaming_download_file
    return false if !has_streaming_resource?

    @reserve.url
  end


  def download_file_path
    return false if !has_file_resource?
    p @reserve.pdf.path
    @reserve.pdf.path
  end


  def redirect_url
    return false if !has_url_resource?

    @reserve.url
  end


  def complete?
    !can_have_resource? || has_resource?
  end

end
