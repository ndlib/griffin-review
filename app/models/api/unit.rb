module API
  class Unit < Base
    BASE_PATH = "/1.0/orgs/"

    def self.find(id)
      result = get_json("library/#{id}")
      result["orgs"].first
    end

    def self.all
      result = get_json('library/all')
      result["orgs"]
    end
  end
end
