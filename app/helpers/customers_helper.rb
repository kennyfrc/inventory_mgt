module CustomersHelper

  def array_of_arrays_customers
    Customer.all.map{|customer| [customer.company_name.capitalize, customer.id]}
  end
end
