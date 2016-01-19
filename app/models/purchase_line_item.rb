class PurchaseLineItem < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :product_description
end
