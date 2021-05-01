class Stock < ApplicationRecord
  # Validations
  validates :name, :ticker, :last_price, presence: true
  # Associations
  has_many :user_stocks, dependent: :destroy
  has_many :users, through: :user_stocks

  class << self
    def check_db(ticker_symbol)
      find_by(ticker: ticker_symbol.upcase)
    end

    def new_lookup(company_name)
      ticker_symbol = retrieve_ticker_symbol(company_name)

      create_stock(ticker_symbol)
    rescue StandardError => error
      error_message = {
        ticker: ticker_symbol,
        error: error.message
      }.to_json

      Rails.logger.error(error_message)
      nil
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

    def update_price_and_performance(stock)
      look_up = new_lookup(stock.ticker)

      stock.last_price = look_up.last_price
      stock.recent_performance = look_up.recent_performance
      stock.save
      stock
    end

    private

    def create_stock(ticker_symbol)
      new(
        ticker: ticker_symbol,
        name: iex_client.company(ticker_symbol).company_name,
        last_price: iex_client.price(ticker_symbol),
        recent_performance: iex_client.key_stats(ticker_symbol).day_5_change_percent_s
      )
    end

    def retrieve_ticker_symbol(company_name)
      yahoo_client.get_ticker_symbol(company_name)
    end

    def iex_client
      # Run -> $ EDITOR="code --wait" rails credentials:edit
      # to store credentials
      @iex_client ||= IEX::Api::Client.new(
        publishable_token: Rails.application.credentials.iex_client[:sandbox_api_token],
        secret_token: Rails.application.credentials.iex_client[:sandbox_secret_token],
        endpoint: 'https://sandbox.iexapis.com/v1'
      )
    end

    def yahoo_client
      @yahoo_client ||= ApiClients::YahooApi::ApiClient.new(
        ApiClients::YahooApi::Config.new
      )
    end
  end
end
