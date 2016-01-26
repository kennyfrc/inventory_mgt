class AddMailForPartnerToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :mail_for_partner_id, :integer
    add_index :suppliers, :mail_for_partner_id
  end
end
