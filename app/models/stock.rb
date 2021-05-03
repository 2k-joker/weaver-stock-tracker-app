class Stock < ApplicationRecord
  # Validations
  validates :name, :ticker, :last_price, presence: true

  # Associations
  has_many :user_stocks, dependent: :destroy
  has_many :users, through: :user_stocks

  class << self
    def find_by_ticker(ticker_symbol)
      find_by(ticker: ticker_symbol.upcase)
    end

    def lookup(company_name)
      ticker_symbol = retrieve_ticker_symbol(company_name)

      build_stock_object(ticker_symbol)
    rescue StandardError => error
      log_stock_lookup_error(ticker_symbol, error)
    end

    def most_active
      iex_client.stock_market_list(:mostactive)
    end

    def top_gainers
      iex_client.stock_market_list(:gainers)
    end

    def top_losers
      iex_client.stock_market_list(:losers)
    end

    private

    def build_stock_object(ticker_symbol)
      new(
        ticker: ticker_symbol,
        name: iex_client.company(ticker_symbol).company_name,
        last_price: iex_client.price(ticker_symbol),
        recent_performance: iex_client.key_stats(ticker_symbol).day_5_change_percent_s
      )
    end

    def app_credentials
      # Run -> $ EDITOR="code --wait" rails credentials:edit
      # to store credentials
      Rails.application.credentials
    end

    def iex_client
      @iex_client ||= IEX::Api::Client.new(
        publishable_token: app_credentials.iex_client[:sandbox_api_token],
        secret_token: app_credentials.iex_client[:sandbox_secret_token],
        endpoint: 'https://sandbox.iexapis.com/v1'
      )
    end

    def log_stock_lookup_error(ticker_symbol, error)
      error_message = {
        message: 'Error looking up stock data',
        ticker: ticker_symbol,
        error: error.message
      }.to_json

      Rails.logger.error(error_message)
      nil
    end

    def retrieve_ticker_symbol(company_name)
      yahoo_client.get_ticker_symbol(company_name)
    end

    def yahoo_client
      @yahoo_client ||= ApiClients::YahooApi::ApiClient.new(
        ApiClients::YahooApi::Config.new
      )
    end
  end

  def update_price_and_performance
    look_up = self.class.lookup(ticker)

    self.last_price = look_up.last_price
    self.recent_performance = look_up.recent_performance
    save!
  end
end
