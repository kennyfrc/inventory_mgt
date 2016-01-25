class PurchaseOrdersController < ApplicationController
  def index
    @purchase_orders = PurchaseOrder.all
  end

  def new
    @purchase_line_item = PurchaseLineItem.new
    @purchase_order = PurhcaseOrder.new
    @supplier = Supplier.new
  end

  def create
    @purchase_line_item = PurchaseLineItem.new(p_params)
    if @purchase_line_item.save
      flash[:notice] = "Purchase Order is ready to be sent."
      redirect_to @purchase_line_item
    else
      flash[:error] = "There was an error. Try again."
      render :new
    end
  end

  def s_params
    params.require(:purchase_line_item).permit(:price, :units_purchased)
  end
end
