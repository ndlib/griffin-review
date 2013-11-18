
class ElectronicReserve

  def initialize(reserve)
    @reserve = reserve
  end


  def is_electronic_reserve?
    @reserve.electronic_reserve?
  end


  def has_streaming?
    (
      is_electronic_reserve? &&
      ['VideoReserve', 'AudioReserve'].include?(@reserve.type) &&
      !has_redirect?
    )
  end


  def has_redirect?
    is_electronic_reserve? && TextIsUriPolicy.uri?(@reserve.url)
  end


  def has_file_download?
    is_electronic_reserve? && @reserve.pdf.present?
  end


  def type
    reserve_type.class.to_s.gsub('Reserve', '').downcase
  end


  def redirect_url
    reserve_type.redirect_url
  end


  def file_path
    reserve_type.file_path
  end


  def complete?
    !is_electronic_reserve? || (  )
  end

  private

    def reserve_type
      if has_file_download?
        FileReserve.new(@reserve)
      elsif has_streaming?
        StreamingReserve.new(@reserve)
      elsif has_redirect?
        UrlReserve.new(@reserve)
      else
        raise "invalid electrontic reserve"
      end
    end

end
