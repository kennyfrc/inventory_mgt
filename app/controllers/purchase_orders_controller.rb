class PurchaseOrdersController < ApplicationController
  before_action :authenticate_user!
  def index
    @purchase_orders = PurchaseOrder.all
  end

  def new
    @supplier = Supplier.new
    @purchase_order = PurchaseOrder.new
    @purchase_line_item = PurchaseLineItem.new
    @product_descriptions = ProductDescription.all
  end
  
  def show
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do 
        pdf = PoPdf.new(@purchase_order, view_context) # initialize the OrderPdf class # pass an argument as this is required in the class that you've made
        send_data pdf.render, filename: "purchase_order_#{@purchase_order.po_number}.pdf", # pass the filename argument as well to indicate the filename
                              type: "application/pdf", # set this, otherwise it deafults to an application/octet-stream (it means that it's a binary file that needs to be opened in some application, such as a spreadsheet or word processor)
                              disposition: "inline" # just do it inline without downloading it
      pdf.render_file File.join(Rails.root, "tmp", "x.pdf")
      current_user.certificate = File.open("#{Rails.root}/tmp/x.pdf")
      current_user.save!

      end
    end
  end

  
end
