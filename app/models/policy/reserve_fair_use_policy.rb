class ReserveFairUsePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def requires_fair_use?
    return true if ['BookChapterReserve', 'VideoReserve', 'AudioReserve'].include?(@reserve.type)

    return true if 'JournalReserve' == @reserve.type && @reserve.pdf.present?

    return false
  end


  def fair_use_complete?
    !requires_fair_use? || !@reserve.fair_use.nil?
  end

end
