class RequestRowListGroup < Draper::Decorator
  def rows
    object
  end

  def to_json
    # puts "Group to_json - #{cache_key}"
    Rails.cache.fetch(cache_key) do
      # puts "MISS on #{cache_key}"
      to_json_uncached
    end
  end

  def cache_key
    "admin-reserve-group-#{rows_identifier}"
  end

  private

  def plain_rows_identifier
    rows.collect{|row| row.cache_key}.join(',')
  end

  def rows_identifier
    @rows_identifier ||= Digest::SHA1.hexdigest(plain_rows_identifier)
  end

  def to_json_uncached
    rows.collect{|row| h.raw(row.cached_json)}.join(",")
  end
end
