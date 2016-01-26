class AddAttachmentCertificateToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :certificate
    end
  end

  def self.down
    remove_attachment :users, :certificate
  end
end
