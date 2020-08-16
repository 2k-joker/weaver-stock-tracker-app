class AddRecentPerformanceToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :recent_performance, :string
  end
end
