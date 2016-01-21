class DashboardController < ApplicationController
  def show
    @product_descriptions = ProductDescription.all
    @sales_line_items = SalesLineItem.all

    base
    sales_graph
    cost_graph
    profit_graph
    stock_level
    days_on_hand

    if @days_on_hand < 7
      flash[:alert] = "You have less than 7 days worth of stock left (on average). Check 'Study By-SKU Inventory' for more."
    elsif @days_on_hand < 3
      flash[:error] = "Replenish your stock ASAP. You have less than 3 days worth of stock left."
    end
  end

  def investigate_inventory
    @product_descriptions = ProductDescription.where(id: ProductDescription.text_search(params[:query]).map(&:id)) # convert it back to an activerecord::relations
    @sales_line_items = SalesLineItem.all

    base
    sales_graph
    cost_graph
    profit_graph
    stock_level
    days_on_hand

    if @days_on_hand < 7 && @days_on_hand > 2
      flash[:alert] = "Replenish your #{@product_descriptions.pluck(:name)[0]} stock ASAP. You have on average less than 7 days worth of stock left. Check 'Study By-SKU Inventory' for more [In Stock Level Over Time Graph]."
    elsif @days_on_hand < 3
      flash[:error] = "Replenish your #{@product_descriptions.pluck(:name)[0]} stock ASAP. You have less than 3 days worth of stock left."
    end
  end

  private

  def base
    # this is the base for the cumulative data
    @sum_sold, @sum_purch, @sum_rev, @sum_cost, @sum_profit = 0, 0, 0, 0, 0
  end

  def sales_graph
       # sales graph
    @dates = SalesLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").count.map {|key, value| key} 
    @revenue = SalesLineItem.where(product_description: @product_descriptions).map {|a| a.revenue.round(2)} 
    @rev_data = Hash[*@dates.zip(@revenue).flatten].reject {|key, val| val == nil }
    @cumu_rev_data = @rev_data.map { |x,y| { x => (@sum_rev += y) } }.reduce({}, :merge) # without merge it doesn't take out the array  
  end

  def cost_graph
    # cost graph
    @dates2 = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").count.map {|key, value| key} 
    @cost = PurchaseLineItem.where(product_description: @product_descriptions).map {|a| a.cost.round(2)} 
    @cost_data = Hash[*@dates2.zip(@cost).flatten].reject {|key, val| val == nil }
    @cumu_cost_data = @cost_data.map { |x,y| { x => (@sum_cost += y) } }.reduce({}, :merge) # without merge it doesn't take out the array  s
  end

  def profit_graph
    # profit graph
    @profit = @revenue.zip(@cost).map { |r, c| (r - c).round(2)} 
    @profit_data = Hash[*@dates2.zip(@profit).flatten].reject {|key, val| val == nil }
    @cumu_profit_data = @profit_data.map { |x,y| { x => (@sum_profit += y) } }.reduce({}, :merge)
  end

  def stock_level
    # cumulative items sold and purchased
    @dates2 = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").count.map {|key, value| key}
    @cumu_sold = SalesLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_sold).map { |x,y| { x => (@sum_sold += y) } }.reduce({}, :merge).values
    @cumu_purch = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_purchased).map { |x,y| { x => (@sum_purch += y) } }.reduce({}, :merge).values
    @stock_level = @cumu_purch.zip(@cumu_sold).map {|purch, sold| purch - sold }
    @stock_level_data = Hash[*@dates2.zip(@stock_level).flatten]
  end

  def days_on_hand
        # latest stock level
    @latest_stock_level = @stock_level.last

    # average sales (prev 5 days)
    @avg_sales = SalesLineItem.where(product_description: @product_descriptions).where(:created_at => (DateTime.now - 5.days)..(DateTime.now)).average(:units_sold).to_f

    # days on hand 
    @days_on_hand = @latest_stock_level / @avg_sales
  end
end
