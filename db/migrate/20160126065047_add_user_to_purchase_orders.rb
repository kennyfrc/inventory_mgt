class AddUserToPurchaseOrders < ActiveRecord::Migration
  def change
    add_column :purchase_orders, :user_id, :integer
    add_index :purchase_orders, :user_id
  end
end
