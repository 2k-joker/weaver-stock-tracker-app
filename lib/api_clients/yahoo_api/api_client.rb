module ApiClients
  module YahooApi
    class ApiClient
      def initialize(config)
        @config = config
      end

      def get_ticker_symbol(company_name)
        request = api_request(:get, '/autoc', company_name)
        request.response.dig('ResultSet', 'Result', 0, 'symbol')
      end

      private

      attr_reader :company_name, :config

      def api_request(method, path, company_name)
        query = default_query.merge('query' => company_name)
        ApiRequest.new(method, config.base_uri, path, query: query)
      end

      def default_query
        {
          'lang' => config.language
        }
      end
    end
  end
end
