class ProductDescription < ActiveRecord::Base
  belongs_to :product_category
  has_many :sales_line_items
  has_many :purchase_line_items
end
