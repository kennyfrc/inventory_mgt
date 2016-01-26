class AddUserToProductDescriptions < ActiveRecord::Migration
  def change
    add_column :product_descriptions, :user_id, :integer
    add_index :product_descriptions, :user_id
  end
end
