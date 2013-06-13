class ReserveCanBeLinkedToPolicy

  def initialize(reserve)
    @reserve = reserve
  end


  def can_be_linked_to?
    @reserve.semester.current? &&
      (
        ReserveFileResourcePolicy.new(@reserve).has_file_resource? ||
        ReserveUrlResourcePolicy.new(@reserve).has_url_resource?
      )
  end
end
