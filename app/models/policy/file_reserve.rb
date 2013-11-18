class FileReserve


  def initialize(reserve)
    @reserve = reserve
  end


  def is_file_reserve?
    @reserve.pdf.present?
  end


  def redirect_url
    false
  end


  def file_path
    if is_file_reserve?
      @reserve.pdf.file_path
    else
      false
    end
  end

end
