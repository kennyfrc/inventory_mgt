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

  def show
    @sales_order = SalesOrder.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do 
        pdf = SoPdf.new(@sales_order, view_context) # initialize the OrderPdf class # pass an argument as this is required in the class that you've made
        send_data pdf.render, filename: "sales_order_#{@sales_order.so_number}.pdf", # pass the filename argument as well to indicate the filename
                              type: "application/pdf", # set this, otherwise it deafults to an application/octet-stream (it means that it's a binary file that needs to be opened in some application, such as a spreadsheet or word processor)
                              disposition: "inline" # just do it inline without downloading it
      pdf.render_file File.join(Rails.root, "tmp", "x.pdf")
      current_user.certificate = File.open("#{Rails.root}/tmp/x.pdf")
      current_user.save!

      end
    end

  end

end



# @sales_orders.map {|so| so.sales_line_items.map {|li| li.revenue}.reduce(:+) } get total revenue per customer
