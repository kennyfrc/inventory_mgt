class CreateProductDescriptions < ActiveRecord::Migration
  def change
    create_table :product_descriptions do |t|
      t.integer :def_retail_price_in_cents
      t.integer :def_wholesale_price_in_cents
      t.text :description
      t.integer :def_purchase_price_in_cents
      t.integer :initial_stock_level
      t.integer :initial_units_sold
      t.integer :initial_units_purchased
      t.string :name
      t.string :sku
      t.references :product_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
