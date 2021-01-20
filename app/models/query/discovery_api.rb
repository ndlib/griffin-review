require "json"

class DiscoveryApi

  attr_accessor :json_result

  def self.search_by_ids(ids)
    if ids.is_a?(String)
      ids = [ ids ]
    end

    ret = []
    ids.each do | id |
      json = DiscoveryApi.make_request(id)

      ret << DiscoveryApi.new(json) if !json.empty?
    end

    ret
  end


  def data
    {
      title: title,
      creator_contributor: creator_contributor,
      details: details,
      publisher_provider: publisher_provider,
      fulltext_available?: fulltext_available?,
      fulltext_url: fulltext_url.to_s,
      type: type.to_s
    }
  end


  def initialize(json_result)
    @json_result = json_result
  end


  def title
    @json_result["display"]["title"].to_s.truncate(250, :separator => ' ')
  end


  def type
    @json_result['type'].downcase
  end


  def creator_contributor
    @json_result['display']['creator_contributor'].to_s.truncate(250, :separator => ' ')
  end


  def details
    @json_result['display']['details'].to_s.truncate(250, :separator => ' ')
  end


  def publisher_provider
    @json_result['display']['publisher_provider'].to_s.truncate(250, :separator => ' ')
  end


  def availability
    @json_result['display']['availability']
  end


  def available_library
    @json_result['display']['available_library']
  end


  def fulltext_available?
    @json_result['fulltext_available']
  end


  def fulltext_url
    @json_result['links']['fulltext_url']
  end

  def barcode
    @json_result['primo']['search']['lsr09']
  end

  def id
    @json_result['id']
  end

  private

    def self.make_request(id)
      API::Resource.search_catalog(id)
    end

end
