class RequestRowListGroup < Draper::Decorator
  def rows
    object
  end

  def plain_cache_key
    rows.collect{|row| row.cache_key}.join(',')
  end

  def cache_key
    @cache_key ||= Digest::SHA1.hexdigest(plain_cache_key)
  end

  def to_json
    rows.collect{|row| h.raw(row.cached_json)}.join(",")
  end
end
