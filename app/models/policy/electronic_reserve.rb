
class ElectronicReserve

  def initialize(reserve)
    @reserve = reserve
  end


  def is_electronic_reserve?
    @reserve.electronic_reserve?
  end
end
