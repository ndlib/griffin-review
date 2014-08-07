class ReserveInAlephPolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def in_aleph?
    @reserve.currently_in_aleph
  end

end
