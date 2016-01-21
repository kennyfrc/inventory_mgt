class SuppliersController < ApplicationController
  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(s_params)
    if @supplier.save
      flash[:notice] = "Supplier Details were saved"
      redirect_to relationships_path
    else
      flash[:error] = "There was an error. Try again."
      render :new
    end
  end

  private

  def s_params
    params.require(:supplier).permit(:address, :city, :company_name, :country, :description, :email, :fax, :phone, :region, :tax_number, :url)
  end
end
