module API
  class Employee < Person

    def self.all
      result = get_json('library/all')
      result["people"]
    end
  end
end
