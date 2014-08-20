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

  def grouped_rows
    rows.group_by{|row| group_id(row) }
  end

  def build_groups
    group_objects = []
    grouped_rows.each do |base_id, row_array|
      group_objects << build_group(row_array)
    end
    group_objects
  end

  def build_group(row_array)
    RequestRowListGroup.new(row_array)
  end

  def build_rows
    reserves.collect {|reserve| build_row(reserve)}
  end

  def build_row(reserve)
    RequestRow.new(reserve)
  end

  def group_id(row)
    (row.id / row_group_size) * row_group_size
  end

  def row_group_size
    100
  end
end
