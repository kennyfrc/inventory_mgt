class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.text :address
      t.string :city
      t.string :company_name
      t.string :country
      t.text :description
      t.string :email
      t.string :fax
      t.string :phone
      t.string :region
      t.string :tax_number
      t.string :url

      t.timestamps null: false
    end
  end
end
