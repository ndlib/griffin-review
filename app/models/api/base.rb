#file = File.open("path-to-file.tar.gz", "rb")
#contents = file.read

require "addressable/uri"

module API
  class Base
    BASE_PATH = "/"

    def self.base_path
      const_get(:BASE_PATH)
    end

    def self.get_json(path, params = {})
      JSON.parse(get(path, params, :json))
    end

    def self.get(path, params = {}, format = nil)
      require 'open-uri'
      puts api_url(path, params, format)
      open(api_url(path, params, format)).read
    end

    def self.api_url(path, params = {}, format = nil)
      if format.present?
        extension = ".#{format}"
      end
      params[:auth_token] = Rails.configuration.api_token

      File.join(Rails.configuration.api_url, base_path, "#{path}#{extension}?#{convert_params_to_string(params)}")
    end

    protected

      def self.convert_params_to_string(params)
        uri = Addressable::URI.new
        uri.query_values = params
        uri.query
      end
  end
end
