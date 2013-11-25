
class PhysicalReservePolicy


  def initialize(reserve)
    @reserve = reserve
  end


  def is_physical_reserve?
    @reserve.physical_reserve?
  end

end
