class StocksController < ApplicationController
  def search
    if params[:stock]. present?
      @stock = Stock.new_lookup(params[:stock])
      if @stock
        respond_to do |format|
          format.js { render partial: 'users/stock_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "No results found"
          format.js { render partial: 'users/stock_result' }
        end        
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Unless you like hitting buttons, please enter a value to search"
        format.js { render partial: 'users/stock_result' }
      end
    end
  end

  def stats
    @most_active = Stock.most_active
    @top_gainers = Stock.top_gainers
    @top_losers = Stock.top_losers
  end
end