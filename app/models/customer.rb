class Customer < ActiveRecord::Base
  has_many :sales_orders
end
