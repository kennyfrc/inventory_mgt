class SalesOrder < ActiveRecord::Base
  belongs_to :customer
  has_many :sales_line_items
end
