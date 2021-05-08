class ApiRequest
  include HTTParty

  # Constants
  DEFAULT_FORMAT = :json
  DENYLISTED_KEYS = %w[access_token api_key authorization secret].freeze

  # Delegates
  delegate :code, :headers, prefix: :response, to: :@response

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

  def default_headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

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

  def formatted_body(body, format)
    if body.present?
      format_body(body, format)
    end
  end

  def log_request_and_response
    Rails.logger.info("Request: #{redacted_request}")

    if @response
      log_response
    end
  end

  def log_response
    Rails.logger.info("Response code: #{response_code}")

    unless @response.internal_server_error?
      Rails.logger.info("Response body: #{response}")
    end

    Rails.logger.info("Response headers: #{response_headers}")
  end

  def make_api_request
    @response = HTTParty.public_send(*httparty_params)
  ensure
    log_request_and_response
  end

  def redacted_request
    @httparty_params.deep_dup.tap do |params|
      redact_headers(params.last[:headers])
    end
  end

  def redact_headers(headers)
    headers&.each do |header, value|
      if DENYLISTED_KEYS.include?(header.to_s)
        headers[header] = value.truncate(10)
      end
    end
  end

  def request_format
    options[:format] || DEFAULT_FORMAT
  end

  def request_options
    {
      base_uri: base_uri,
      body: formatted_body(options[:body], request_format),
      follow_redirects: true,
      headers: default_headers.merge(options[:headers] || {}),
      query: options[:query]
    }.compact
  end
end
