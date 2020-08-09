class UsersController < ApplicationController
  def my_friends
    @friends = current_user.friends
  end

  def my_portfolio
    @tracked_stocks = current_user.stocks
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
end
