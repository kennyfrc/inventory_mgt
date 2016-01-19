class ProductCategory < ActiveRecord::Base
  has_many :product_descriptions
end
