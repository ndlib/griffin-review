module API
  class Service
    SERVICES = {
      employee: Employee,
      unit: Unit
    }
    def self.get(service)
      SERVICES[service]
    end
  end
end
