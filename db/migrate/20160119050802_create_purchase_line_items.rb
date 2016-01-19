class CreatePurchaseLineItems < ActiveRecord::Migration
  def change
    create_table :purchase_line_items do |t|
      t.integer :price_in_cents
      t.integer :units_purchased
      t.references :purchase_order, index: true, foreign_key: true
      t.references :product_description, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
