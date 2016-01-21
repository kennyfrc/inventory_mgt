class SalesOrdersController < ApplicationController
  def index
    @sales_orders = SalesOrder.all
  end
end



# @sales_orders.map {|so| so.sales_line_items.map {|li| li.revenue}.reduce(:+) } get total revenue per customer
