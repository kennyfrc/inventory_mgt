class RelationshipsController < ApplicationController
  def index
    @relationships = Customer.all + Supplier.all # this converts it into an array of Customer and Supplier objects (not AR)
  end
end
