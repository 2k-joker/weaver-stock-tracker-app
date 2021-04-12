class ApiRequest
  include HTTParty

  # Constants
  DEFAULT_FORMAT = :json

  def initialize(method, base_uri, url, options = {})
    @base_uri = base_uri
    @options = options

    @httparty_params = [method.to_s, url, request_options]
    make_api_request
  end

  def response
    @response.parsed_response
  end

  private

  attr_reader :base_uri, :httparty_params, :options

  def format_body(body, format)
    case format
    when :json
      body.to_json
    when :text
      body
    else
      raise(NotImplementedError, "Unsupported format type: #{format}")
    end
  end

  def request_format
    options[:format] || DEFAULT_FORMAT
  end

  def formatted_body(body, format)
    unless body.blank?
      format_body(body, format)
    end
  end

  def make_api_request
    @response = HTTParty.public_send(*httparty_params)
  end

  def request_options
    {
      base_uri: base_uri,
      body: formatted_body(options[:body], request_format),
      follow_redirects: true,
      headers: options[:headers],
      query: options[:query]
    }.compact
  end
end