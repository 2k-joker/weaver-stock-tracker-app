class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validations
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  def can_track_stock?(ticker_symbol)
    within_stock_limit? && !alread_tracking_stock?(ticker_symbol)
  end

  def alread_tracking_stock?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end
  def within_stock_limit?
    stocks.count < 10
  end
end
