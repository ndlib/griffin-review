module API
  class Person < Base
    BASE_PATH = "/1.0/people/"

    def self.find(netid)
      result = get_json("by_netid/#{netid}")
      result["people"].first
    end
  end
end
