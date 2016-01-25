module SuppliersHelper


  def array_of_arrays_suppliers
    Supplier.all.map{|supplier| [supplier.company_name.capitalize, supplier.id]}
  end

end
