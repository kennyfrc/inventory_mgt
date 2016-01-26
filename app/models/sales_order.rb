class SalesOrder < ActiveRecord::Base
  belongs_to :customer
  belongs_to :user
  has_many :sales_line_items
end
