class Supplier < ActiveRecord::Base
  has_many :purchase_orders
  belongs_to :user
end
