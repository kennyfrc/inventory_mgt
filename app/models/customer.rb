class Customer < ActiveRecord::Base
  has_many :sales_orders
  belongs_to :user
end
