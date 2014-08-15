class RequestRowList < Draper::Decorator
  def request_list
    object
  end

  def reserves
    request_list.reserves
  end

  def groups
    @groups ||= build_groups
    # raise @groups.inspect
  end

  def build_groups
    groups = []
    rows.group_by{|row| row.reserve.id.round(-2) }.each do |base_id, grouped_rows|
      groups << RequestRowListGroup.new(grouped_rows)
    end
    groups
  end

  def rows
    @rows ||= reserves.collect {|reserve| RequestRow.new(reserve)}
  end

  def to_json
    h.raw groups.collect{|group| group.to_json}.join(",")
  end
end
