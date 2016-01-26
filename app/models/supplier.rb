class Supplier < ActiveRecord::Base
  has_many :purchase_orders
  belongs_to :user
  has_many :mail_for_partners
end
