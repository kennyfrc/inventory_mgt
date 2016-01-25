class PurchaseLineItemsController < ApplicationController


  def create
    @purchase_line_item = PurchaseLineItem.new(p_params)
    if params[:purchase_line_item][:purchase_order][:po_number].present? && params[:purchase_line_item][:purchase_order][:supplier_id].present? #if it *is* a pop_out_form and there's a value present
      new_PO = PurchaseOrder.create(po_number: params[:purchase_line_item][:purchase_order][:po_number], supplier_id: params[:purchase_line_item][:purchase_order][:supplier_id]) # then set the value to new_category
      if new_PO # if new_category exists
        @purchase_line_item.purchase_order_id = new_PO.id #set the ID of new_category to product_description.product_category_id (automatically sets teh value??)
      end
    end

    if params[:purchase_line_item][:product_description][:product_description_id] && params[:purchase_line_item][:product_description][:product_description_id].present?
      @purchase_line_item.product_description_id = ProductDescription.find_by(name: params[:purchase_line_item][:product_description][:product_description_id]).id
    end

    if @purchase_line_item.save
      flash[:notice] = "Purchase Order is ready to be sent."
      redirect_to purchase_order_path(@purchase_line_item)
    else
      flash[:error] = "There was an error. Try again."
      render :new
    end
  end

  def show

  end

  private

  def p_params
    params.require(:purchase_line_item).permit(:price, :units_purchased, :purchase_order_id, :product_description_id)
  end
  
end
