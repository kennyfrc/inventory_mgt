class SalesLineItemsController < ApplicationController

  def create
    @sales_line_item = SalesLineItem.new(s_params)
    if params[:sales_line_item][:sales_order][:so_number].present? && params[:sales_line_item][:sales_order][:customer_id].present? #if it *is* a pop_out_form and there's a value present
      new_SO = SalesOrder.create(so_number: params[:sales_line_item][:sales_order][:so_number], customer_id: params[:sales_line_item][:sales_order][:customer_id]) # then set the value to new_category
      if new_SO # if new_category exists
        @sales_line_item.sales_order_id = new_SO.id #set the ID of new_category to product_description.product_category_id (automatically sets teh value??)
      end
    end

    if params[:sales_line_item][:product_description][:product_description_id] && params[:sales_line_item][:product_description][:product_description_id].present?
      @sales_line_item.product_description_id = ProductDescription.find_by(name: params[:sales_line_item][:product_description][:product_description_id]).id
    end

    if @sales_line_item.save
      flash[:notice] = "Sales Order is ready to be sent."
      redirect_to sales_order_path(@sales_line_item)
    else
      flash[:error] = "There was an error. Try again."
      render :new
    end
  end

  def show

  end

  private

  def s_params
    params.require(:sales_line_item).permit(:price, :units_sold, :sales_order_id, :product_description_id)
  end
  
end
