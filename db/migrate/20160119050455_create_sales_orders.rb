class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|
      t.string :so_number
      t.references :customer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
