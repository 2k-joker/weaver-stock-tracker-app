class UsersController < ApplicationController
  def my_friends
    @friends = current_user.friends
  end

  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_profile; end

  def refresh
    update_user_stocks(current_user.stocks)
    redirect_to my_portfolio_path
  rescue StandardError
    flash[:alert] = 'Oops! Could not refresh stocks. Please try again.'
  end

  def search
    if params[:friend].present?
      users = User.search(params[:friend])
      @friends = current_user.except_current_user(users)
      if @friends.any?
        respond_to do |format|
          format.js { render partial: 'users/friend_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = 'No results found. Invite them to sign up!'
          format.js { render partial: 'users/friend_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'Unless you like hitting buttons for fun, please enter a value to search'
        format.js { render partial: 'users/friend_result' }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks.order('id')
  end

  private

  def log_invalid_record_error(stock, error)
    error_message = {
      message: 'Failed to save invalid stock record',
      ticker: stock.ticker,
      error: error.message
    }.to_json

    Rails.logger.error(error_message)
  end

  def update_stock(stock)
    stock.update_price_and_performance
    stock.save!
  rescue ActiveRecord::RecordInvalid => error
    log_invalid_record_error(stock, error)
    raise(error)
  end

  def update_user_stocks(user_stocks)
    user_stocks.map { |stock| update_stock(stock) }
  end
end
