class AddUserToSalesOrders < ActiveRecord::Migration
  def change
    add_column :sales_orders, :user_id, :integer
    add_index :sales_orders, :user_id
  end
end
