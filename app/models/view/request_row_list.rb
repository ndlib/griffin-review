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
end
