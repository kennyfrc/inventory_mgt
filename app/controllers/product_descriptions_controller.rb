class ProductDescriptionsController < ApplicationController

  def index
    @product_descriptions = ProductDescription.all
    @product_categories = ProductCategory.all

    base
    stock_level
  end

  private

    def base
      # this is the base for the cumulative data
      @sum_sold, @sum_purch, @sum_rev, @sum_cost, @sum_profit = 0, 0, 0, 0, 0
    end

   def stock_level
    # cumulative items sold and purchased
    @dates2 = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").count.map {|key, value| key}
    @cumu_sold = SalesLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_sold).map { |x,y| { x => (@sum_sold += y) } }.reduce({}, :merge).values
    @cumu_purch = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_purchased).map { |x,y| { x => (@sum_purch += y) } }.reduce({}, :merge).values
    @stock_level = @cumu_purch.zip(@cumu_sold).map {|purch, sold| purch - sold }
    @stock_level_data = Hash[*@dates2.zip(@stock_level).flatten]
  end

end
