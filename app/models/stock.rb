class Stock < ApplicationRecord
  def self.new_lookup(ticker_symbol)
    # Run -> $ EDITOR="code --wait" rails credentials:edit
    # to store credentials
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_token],
      secret_token: Rails.application.credentials.iex_client[:sandbox_secret_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    client.price(ticker_symbol)
  end
end
