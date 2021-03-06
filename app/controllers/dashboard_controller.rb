class DashboardController < ApplicationController
  before_action :authenticate_user!
  def show
    @product_descriptions = ProductDescription.all
    @sales_line_items = SalesLineItem.all

    base
    sales_graph
    cost_graph
    profit_graph
    stock_level
    days_on_hand
    xy_data_for_profit
    formatting_data_for_profit
    xy_data_for_stocks
    formatting_data_for_stocks

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
    xy_data_for_profit
    formatting_data_for_profit

    if @days_on_hand < 7 && @days_on_hand > 2
      flash[:alert] = "Replenish your #{@product_descriptions.pluck(:name)[0]} stock ASAP. You have on average less than 7 days worth of stock left. Check 'Study By-SKU Inventory' for more [In Stock Level Over Time Graph]."
    elsif @days_on_hand < 3
      flash[:error] = "Replenish your #{@product_descriptions.pluck(:name)[0]} stock ASAP. You have less than 3 days worth of stock left."
    else
      flash[:error] = "ERROR in Dashboard#Controller"
    end
  end

  private

  def xy_data_for_profit
    @xy_data_for_profit = [
      {name: "Profit", data: @cumu_profit_data },
      {name: "Revenue", data: @cumu_rev_data},
      {name: "Cost", data: @cumu_cost_data }
    ]
  end

  def formatting_data_for_profit
  end

  def xy_data_for_stocks
    @xy_data_for_stocks = 
    [
      {name: "Stock Level", data: @stock_level_data } 
    ]
  end
  
  def formatting_data_for_stocks
  end

  def base
    # this is the base for the cumulative data
    @sum_sold, @sum_purch, @sum_rev, @sum_cost, @sum_profit = 0, 0, 0, 0, 0
  end

  def sales_graph
    # sales graph
    @dates = SalesLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").count.map {|key, value| key} 
    initial_date_time = @dates.first ? DateTime.strptime(@dates.first, "%B %d, %Y") - 1.days : DateTime.now
    @parsed_date_time = initial_date_time.strftime("%B %d, %Y")
    @dates = @dates.unshift(@parsed_date_time) 
    init_revenue = @product_descriptions.map {|e| e.init_revenue}.reduce(:+)
    @revenue = SalesLineItem.where(product_description: @product_descriptions).map {|a| a.revenue.round(2)} 
    @revenue = @revenue.unshift(init_revenue)
    @rev_data = Hash[*@dates.zip(@revenue).flatten].reject {|key, val| val == nil }
    @cumu_rev_data = @rev_data.map { |x,y| { x => (@sum_rev += y).round(2) } }.reduce({}, :merge) # without merge it doesn't take out the array  
  end

  def cost_graph
    # cost graph
    @dates2 = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").count.map {|key, value| key} 
    initial_date_time_cost = @dates2.first ? DateTime.strptime(@dates.first, "%B %d, %Y") - 1.days : DateTime.now
    @parsed_date_time_cost = initial_date_time_cost.strftime("%B %d, %Y")
    @dates2 = @dates2.unshift(@parsed_date_time_cost)
    init_cost = @product_descriptions.map {|e| e.init_cost}.reduce(:+)
    @cost = PurchaseLineItem.where(product_description: @product_descriptions).map {|a| a.cost.round(2)} 
    @cost = @cost.unshift(init_cost)
    @cost_data = Hash[*@dates2.zip(@cost).flatten].reject {|key, val| val == nil }
    @cumu_cost_data = @cost_data.map { |x,y| { x => (@sum_cost += y) } }.reduce({}, :merge) # without merge it doesn't take out the array  s
  end

  def profit_graph
    # profit graph
    if @revenue.count > @cost.count
      injector = @revenue.count - @cost.count
      injector.times do 
        @cost << 0
      end
    elsif @revenue.count < @cost.count
      injector = @cost.count - @revenue.count
      injector.times do
        @revenue << 0
      end
    end
    @profit = @revenue.zip(@cost).map { |r, c| (r - c).round(2)} 
    @profit_data = Hash[*@dates2.zip(@profit).flatten].reject {|key, val| val == nil }
    @cumu_profit_data = @profit_data.map { |x,y| { x => (@sum_profit += y) } }.reduce({}, :merge)
  end

  def stock_level
    # cumulative items sold and purchased
    @dates2 = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").count.map {|key, value| key}
    @cumu_sold = SalesLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_sold).map { |x,y| { x => (@sum_sold += y) } }.reduce({}, :merge).values
    @cumu_sold[0] ? @cumu_sold : @cumu_sold << 0
    @cumu_purch = PurchaseLineItem.where(product_description: @product_descriptions).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_purchased).map { |x,y| { x => (@sum_purch += y) } }.reduce({}, :merge).values
    init_stock = @product_descriptions.map {|e| e.initial_stock_level}.reduce(:+)
    if @cumu_sold.count > @cumu_purch.count
      injector = @cumu_sold.count - @cumu_purch.count
      injector.times do 
        @cost << 0
      end
    elsif @cumu_sold.count < @cumu_purch.count
      injector = @cumu_purch.count - @cumu_sold.count
      injector.times do
        @cumu_sold << 0
      end
    end
    @stock_level = @cumu_purch.zip(@cumu_sold).map {|purch, sold| purch - sold }
    @stock_level = @stock_level.unshift(init_stock)
    @stock_level_data = Hash[*@dates2.zip(@stock_level).flatten]
  end

  def days_on_hand
    # latest stock level
    @latest_stock_level = @stock_level.last

    # average sales (prev 5 days)
    @avg_sales = SalesLineItem.where(product_description: @product_descriptions).where(:created_at => (DateTime.now - 5.days)..(DateTime.now)).average(:units_sold).to_f

    # days on hand 
    return @days_on_hand = 0 if @avg_sales == 0
    @days_on_hand = @latest_stock_level / @avg_sales
  end
end
