class Stock < ApplicationRecord
  # Validations
  validates :name, :ticker, :last_price, presence: true
  # Associations
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.check_db(ticker_symbol)
    ticker_symbol.upcase!
    where(ticker: ticker_symbol).first
  end

  def self.new_lookup(ticker_symbol)
    ticker_symbol.upcase!
    client = new_client
    begin
      new(
        ticker: ticker_symbol,
        name: client.company(ticker_symbol).company_name,
        last_price: client.price(ticker_symbol)
      )
    rescue => exception
      return nil
    end
  end

  def self.most_active
    client = new_client
    client.stock_market_list(:mostactive)
  end
    
  def self.top_gainers
    client = new_client
    client.stock_market_list(:gainers)
  end

  def self.top_losers
    client = new_client
    client.stock_market_list(:losers)
  end
  
  def self.update_price(stock)
    new_price = new_lookup(stock.ticker).last_price

    return stock unless stock.last_price != new_price

    stock.last_price = new_price
    stock.save
    stock
  end

  private

  def self.new_client
    # Run -> $ EDITOR="code --wait" rails credentials:edit
    # to store credentials
    client ||= IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_token],
      secret_token: Rails.application.credentials.iex_client[:sandbox_secret_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
  end
end
