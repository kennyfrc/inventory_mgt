class PurchaseOrder < ActiveRecord::Base
  belongs_to :supplier
  belongs_to :user
  has_many :purchase_line_items
end
