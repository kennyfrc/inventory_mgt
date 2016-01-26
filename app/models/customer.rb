class Customer < ActiveRecord::Base
  has_many :sales_orders
  belongs_to :user
  has_many :mail_for_partners
end
