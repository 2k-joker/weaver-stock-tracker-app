module ApiClients
  module YahooApi
    class Config
      # Constants
      DEFAULT_BASE_URI = 'http://d.yimg.com/autoc.finance.yahoo.com'.freeze
      DEFAULT_LANGUAGE = 'EN'.freeze

      def initialize(base_uri: nil, language: nil)
        @base_uri = base_uri
        @language = language
      end

      def base_uri
        @base_uri || DEFAULT_BASE_URI
      end

      def language
        @language || DEFAULT_LANGUAGE
      end
    end
  end
end
