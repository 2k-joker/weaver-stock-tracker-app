class Stock < ApplicationRecord
  # Validations
  validates :name, :ticker, :last_price, presence: true
  # Associations
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.check_db(ticker_symbol)
    ticker_symbol.upcase!
    find_by(ticker: ticker_symbol)
  end

  def self.new_lookup(company_name)
    ticker_symbol = retrieve_ticker_symbol(company_name)

    begin
      new(
        ticker: ticker_symbol,
        name: iex_client.company(ticker_symbol).company_name,
        last_price: iex_client.price(ticker_symbol),
        recent_performance: iex_client.key_stats(ticker_symbol).day_5_change_percent_s
      )
    rescue => exception
      return nil
    end
  end

  def self.most_active
    iex_client.stock_market_list(:mostactive)
  end

  def self.top_gainers
    iex_client.stock_market_list(:gainers)
  end

  def self.top_losers
    iex_client.stock_market_list(:losers)
  end
  
  def self.update_price_and_performance(stock)
    look_up = new_lookup(stock.ticker)
    new_performance = look_up.recent_performance
    new_price = look_up.last_price

    return stock unless updated?(stock, new_price, new_performance)

    stock.last_price = new_price unless !updated_price?(stock, new_price)
    stock.recent_performance = new_performance unless !updated_performance?(stock, new_performance)
    stock.save
    stock
  end

  private

  def self.retrieve_ticker_symbol(company_name)
    yahoo_client.get_ticker_symbol(company_name)
  end

  def self.updated?(stock, new_price, new_performance)
    updated_price?(stock, new_price) || updated_performance?(stock, new_performance)
  end

  def self.updated_price?(stock,new_price)
    stock.last_price != new_price
  end

  def self.updated_performance?(stock,new_performance)
    stock.recent_performance != new_performance
  end

  def self.iex_client
    # Run -> $ EDITOR="code --wait" rails credentials:edit
    # to store credentials
    client ||= IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_token],
      secret_token: Rails.application.credentials.iex_client[:sandbox_secret_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
  end

  def self.yahoo_client
    config = ApiClients::YahooApi::Config.new
    ApiClients::YahooApi::ApiClient.new(config)
  end
end
