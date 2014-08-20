class RequestRowList < Draper::Decorator
  def request_list
    object
  end

  def reserves
    @reserves ||= request_list.reserves
  end

  def groups
    @groups ||= build_groups
  end

  def rows
    @rows ||= build_rows
  end

  def to_json
    h.raw groups.collect{|group| group.to_json}.join(",")
  end

  private

  def build_groups
    group_objects = []
    rows.group_by{|row| row_id_group(row) }.each do |base_id, grouped_rows|
      group_objects << RequestRowListGroup.new(grouped_rows)
    end
    group_objects
  end

  def build_rows
    reserves.collect {|reserve| RequestRow.new(reserve)}
  end

  def row_id_group(row)
    (row.id / row_group_size) * row_group_size
  end

  def row_group_size
    100
  end
end
