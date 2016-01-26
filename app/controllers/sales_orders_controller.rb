class SalesOrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    @sales_orders = SalesOrder.all
  end

  def new
    @customer = Customer.new
    @sales_order = SalesOrder.new
    @sales_line_item = SalesLineItem.new
    @product_descriptions = ProductDescription.all
  end

end



# @sales_orders.map {|so| so.sales_line_items.map {|li| li.revenue}.reduce(:+) } get total revenue per customer
