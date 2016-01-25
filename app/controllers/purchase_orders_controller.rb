class PurchaseOrdersController < ApplicationController
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

  end

  
end
