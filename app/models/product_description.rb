class ProductDescription < ActiveRecord::Base
  belongs_to :product_category
  belongs_to :user
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

  def def_purchase_price
    def_purchase_price_in_cents.to_f / 100 || read_attribute(:def_purchase_price)
  end

  def def_purchase_price=(p)
    write_attribute(:def_purchase_price_in_cents, p.to_f.round(2) * 100)
  end

  def init_revenue
    if initial_units_sold
      def_retail_price * initial_units_sold
    else
      initial_units_sold = 0
      def_retail_price * initial_units_sold
    end
  end

  def init_cost
    if initial_units_purchased
      def_purchase_price * initial_units_purchased
    else
      initial_units_purchased = 0
      def_purchase_price * initial_units_purchased
    end
  end
end