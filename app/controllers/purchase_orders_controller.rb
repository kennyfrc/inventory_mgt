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
  end

  
end
