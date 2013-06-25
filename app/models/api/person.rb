module API
  class Person < Base
    BASE_PATH = "/1.0/people/"

    def self.find(netid)
      result = get_json("by_netid/#{netid}")
      result["people"].first
    end


    def self.courses(netid, semester)
      path = File.join("by_netid", netid, semester, "courses")

      result = get_json(path)
      result["people"].first
    end
  end
end
