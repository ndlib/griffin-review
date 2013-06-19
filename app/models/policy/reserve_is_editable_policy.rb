class ReserveIsEditablePolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def is_editable?
    @reserve.semester.current? || @reserve.semester.future?
  end

end
