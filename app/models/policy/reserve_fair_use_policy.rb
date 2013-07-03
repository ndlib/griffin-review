class ReserveFairUsePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def requires_fair_use?
    return true if ['BookChapterReserve', 'VideoReserve', 'AudioReserve'].include?(@reserve.type)

    return true if 'JournalReserve' == @reserve.type && @reserve.pdf.present?

    return false
  end


  def complete?
    !requires_fair_use? || @reserve.fair_use.complete?
  end

end
