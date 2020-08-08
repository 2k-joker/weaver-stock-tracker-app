class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    # Run -> $ EDITOR="code --wait" rails credentials:edit
    # to store credentials
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_token],
      secret_token: Rails.application.credentials.iex_client[:sandbox_secret_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
   
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
end
