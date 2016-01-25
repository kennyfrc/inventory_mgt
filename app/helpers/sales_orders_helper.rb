module SalesOrdersHelper

  def array_of_arrays_products
    ProductDescription.all.map {|pd| pd.name }
  end

end
