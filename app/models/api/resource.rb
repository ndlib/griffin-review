module API
  class Resource < Base
    BASE_PATH = "/1.0/resources/"

    def self.find(netid)
      result = get_json("by_netid/#{netid}")
      result["people"].first
    end


    def self.search_catalog(q)
      q = fix_id(q)
      result = get_json("search/id", {:q => q})

      if result["records"].nil?
        ""
      else
        result["records"].first
      end
    end


    def self.fix_id(id)
      if id.match(/^[0-9]{9}$/)
        "ndu_aleph#{id}"
      else
        id
      end
    end

  end
end
