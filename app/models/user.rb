class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 25 }

  def alread_tracking_stock?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def can_track_stock?(ticker_symbol)
    within_stock_tracking_limit? && !alread_tracking_stock?(ticker_symbol)
  end

  def within_stock_tracking_limit?
    stocks.count < 10
  end
end
