class ProductDescription < ActiveRecord::Base
  belongs_to :product_category
  has_many :sales_line_items
  has_many :purchase_line_items

  def self.text_search(query)
    if query.present?
      where("name ilike :q or sku ilike :q", q: "%#{query}%") 
    else
      take(1)
    end
  end
end