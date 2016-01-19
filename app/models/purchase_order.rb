class PurchaseOrder < ActiveRecord::Base
  belongs_to :supplier
  has_many :purchase_line_items
end
