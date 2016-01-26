class CreateMailForPartners < ActiveRecord::Migration
  def change
    create_table :mail_for_partners do |t|
      t.string :email
      t.string :subject
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
