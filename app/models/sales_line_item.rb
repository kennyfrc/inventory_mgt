class SalesLineItem < ActiveRecord::Base
  belongs_to :sales_order
  belongs_to :product_description
end
