class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  def index
    @relationships = Customer.all + Supplier.all # this converts it into an array of Customer and Supplier objects (not AR)
  end
end
