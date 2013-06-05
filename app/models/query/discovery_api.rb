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


  def initialize(json_result)
    @json_result = json_result
  end


  def title
    @json_result["display"]["title"]
  end


  def creator_contributor
    @json_result['display']['creator_contributor']
  end


  def details
    @json_result['display']['details']
  end


  def publisher_provider
    @json_result['display']['publisher_provider']
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


  private

    def self.make_request(id)
      API::Resource.search_catalog(id)
    end

end
