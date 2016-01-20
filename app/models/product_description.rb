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

  def def_retail_price
    def_retail_price_in_cents.to_f / 100 || read_attribute(:def_retail_price)
  end

  def def_retail_price=(p)
    write_attribute(:def_retail_price_in_cents, p.to_f.round(2) * 100)
  end

  def def_wholesale_price
    def_wholesale_price_in_cents.to_f / 100 || read_attribute(:def_wholesale_price)
  end

  def def_wholesale_price=(p)
    write_attribute(:def_wholesale_price_in_cents, p.to_f.round(2) * 100)
  end

  def init_cost
    initial_cost_in_cents.to_f / 100 || read_attribute(:init_cost)
  end

  def init_cost=(p)
    write_attribute(:initial_cost_in_cents, p.to_f.round(2) * 100)
  end
end