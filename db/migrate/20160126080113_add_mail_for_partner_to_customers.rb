class AddMailForPartnerToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :mail_for_partner_id, :integer
    add_index :customers, :mail_for_partner_id
  end
end
