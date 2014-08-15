class RequestRowList < Draper::Decorator
  def request_list
    object
  end

  def reserves
    request_list.reserves
  end

  def rows
    reserves.collect {|reserve| RequestRow.new(reserve)}
  end

  def to_json
    h.raw rows.collect{|row| row.cached_json}.join(",")
  end
end
