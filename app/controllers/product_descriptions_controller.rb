class ProductDescriptionsController < ApplicationController

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
    @product_description = ProductDescription.new
    @product_category = ProductCategory.new
    if @product_description.save
      flash[:notice] = "Product was saved"
      render :new
    else
      flash[:error] = "There was an error. Try again."
      render :new
    end
  end

  private

  def pd_params
    params.require(:product_description).permit(:def_retail_price_in_cents, :def_wholesale_price_in_cents, :description, :initial_cost_in_cents, :initial_stock_level, :name, :sku)
  end

  def pc_params
    params.require(:product_category).permit(:category)
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
      @stock_level = @cumu_purch.zip(@cumu_sold).map {|purch, sold| purch - sold }
      arr << product.name << @stock_level.last
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