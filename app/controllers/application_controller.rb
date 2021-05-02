class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def refresh_stocks(stocks)
    stocks&.each { |stock| Stock.update_price_and_performance_for(stock) }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :username, :remember_me])
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:username, :email, :remember_me)
    end
  end
end
