class ProductDescriptionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @product_descriptions = ProductDescription.all
    @product_categories = ProductCategory.all

    base
    stock_level
    avg_sales
  end

  def new
    @product_description = ProductDescription.new
    @product_category = ProductCategory.new
  end


  def create
    @product_description = ProductDescription.new(pd_params)
    if params[:product_description][:product_category_id] == 'pop_out_form' && params[:product_description][:product_category][:category].present? #if it *is* a pop_out_form and there's a value present
      new_category = ProductCategory.create(category: params[:product_description][:product_category][:category]) # then set the value to new_category
      if new_category # if new_category exists
        @product_description.product_category_id = new_category.id #set the ID of new_category to product_description.product_category_id (automatically sets teh value??)
      end
    end
    # @product_category = ProductCategory.new
    if @product_description.save
      flash[:notice] = "Product was saved"
      redirect_to product_descriptions_path
    else
      flash[:error] = "There was an error. Try again."
      render :new
    end
  end

  private

  def pd_params
    params.require(:product_description).permit(:def_retail_price, :def_wholesale_price, :description, :initial_purchase_price, :initial_stock_level, :name, :sku, :product_category_id)
  end

  def base
      # this is the base for the cumulative data
    @sum_sold, @sum_purch = 0, 0
  end

  def stock_level
    arr = []
    @product_descriptions.each do |product|
      @sum_sold = 0
      @sum_purch = 0
      @cumu_sold = SalesLineItem.where(product_description: @product_descriptions.where(name: product.name)).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_sold).map { |x,y| { x => (@sum_sold += y) } }.reduce({}, :merge).values
      @cumu_purch = PurchaseLineItem.where(product_description: @product_descriptions.where(name: product.name)).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_purchased).map { |x,y| { x => (@sum_purch += y) } }.reduce({}, :merge).values
    if @cumu_sold.count > @cumu_purch.count
      injector = @cumu_sold.count - @cumu_purch.count
      injector.times do 
        @cumu_purch << 0
      end
    elsif @cumu_sold.count < @cumu_purch.count
      injector = @cumu_purch.count - @cumu_sold.count
      injector.times do
        @cumu_sold << 0
      end
    end
      @stock_level = @cumu_purch.zip(@cumu_sold).map {|purch, sold| purch - sold }
      arr << product.name << ( @stock_level.last ? @stock_level.last : 0 )
    end
    @stock_level_index = Hash[*arr]
  end

  def avg_sales
    arr = []
    @product_descriptions.each do |product|
      @avg_sales = SalesLineItem.where(product_description: @product_descriptions.where(name: product.name)).where(:created_at => (DateTime.now - 5.days)..(DateTime.now)).average(:units_sold).to_f
      arr << product.name << @avg_sales
    end
    @avg_sales = Hash[*arr]
  end
end

# SalesLineItem.where(product_description: @product_descriptions.where(name: "Banana")).group_by_day(:created_at, format: "%B %d, %Y").sum(:units_sold).keys_last