class CreateSalesLineItems < ActiveRecord::Migration
  def change
    create_table :sales_line_items do |t|
      t.integer :price_in_cents
      t.integer :units_sold
      t.references :sales_order, index: true, foreign_key: true
      t.references :product_description, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
