class UsersController < ApplicationController
  def my_friends
    @friends = current_user.friends
  end

  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_profile

  end

  def refresh
    begin
      stocks = current_user.stocks
      refresh_stocks(stocks)
      redirect_to my_portfolio_path
    rescue => exception
      flash[:alert] = "Oops! Could not refresh stocks. Please try again."
    end    
  end

  def search
    if params[:friend]. present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
      if @friends.any?
        respond_to do |format|
          format.js { render partial: 'users/friend_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "No results found. Invite them to sign up! "
          format.js { render partial: 'users/friend_result' }
        end        
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Unless you like hitting buttons, please enter a value to search"
        format.js { render partial: 'users/friend_result' }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks.order('id')
  end
end
