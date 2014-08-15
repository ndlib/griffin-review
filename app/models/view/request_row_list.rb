class RequestRowList < Draper::Decorator
  def request_list
    object
  end

  def reserves
    request_list.reserves
  end

  def groups
    @groups ||= build_groups
  end

  def rows
    @rows ||= reserves.collect {|reserve| RequestRow.new(reserve)}
  end

  def to_json
    h.raw groups.collect{|group| group.to_json}.join(",")
  end

  private

  def build_groups
    group_objects = []
    rows.group_by{|row| row.reserve.id.round(-2) }.each do |base_id, grouped_rows|
      group_objects << RequestRowListGroup.new(grouped_rows)
    end
    group_objects
  end
end
