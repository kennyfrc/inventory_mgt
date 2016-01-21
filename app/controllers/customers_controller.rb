class CustomersController < ApplicationController
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(c_params)
    if @customer.save
      flash[:notice] = "Customer Details were saved"
      redirect_to relationships_path
    else
      flash[:error] = "There was an error. Try again."
      render :new
    end
  end

  private

  def c_params
     params.require(:customer).permit(:address, :city, :company_name, :country, :description, :email, :fax, :phone, :region, :tax_number, :url)
  end
end
