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

  def already_following?(username)
    return true
  end

  def can_track_stock?(ticker_symbol)
    within_stock_tracking_limit? && !alread_tracking_stock?(ticker_symbol)
  end

  def within_stock_tracking_limit?
    stocks.count < 10
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.name_matches(param)
    (matches('first_name ', param) + matches('last_name',param) + 
      matches('username', param)).uniq
  end

  def self.search(param)
    param.strip!
    query_result = (email_matches(param) + name_matches(param)).uniq
    return nil unless query_result
    query_result
  end
end
