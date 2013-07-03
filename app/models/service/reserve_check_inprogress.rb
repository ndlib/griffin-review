class ReserveCheckInprogress


  def initialize(reserve)
    @reserve = reserve
  end


  def check!
    if @reserve.start
      @reserve.save!
    end
  end
end
