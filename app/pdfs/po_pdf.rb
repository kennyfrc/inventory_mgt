class PoPdf < Prawn::Document
  def initialize(purchase_order, view)
    super(top_margin: 70)
          # Ruby's super method lets us call a method in the parent class from within the child class.
          # we can also pass some stuff here as much as we pass stuff to Prawn::Document like top_margin
    @purchase_order = purchase_order # because this is a new class, we don't have access to the instance variable.. so we need to pass it pa
    @view = view
    payable_to
    purchase_order_number
    line_items
    total_price
  end

  def payable_to
    text "Billed To: #{@purchase_order.supplier.company_name}", size: 12, style: :bold 
    text "Address: #{@purchase_order.supplier.address}", size: 10
    text "#{@purchase_order.supplier.city}, #{@purchase_order.supplier.region}", size: 10
    text "#{@purchase_order.supplier.country}", size: 10
  end

  def purchase_order_number
    text "Purchase Order \##{@purchase_order.po_number}", size: 10
  end

  def line_items
    move_down 20 # will be shown 20 lines below the purchase_order number
    table line_item_rows
  end

  def line_item_rows
    [["Product Name", "Quantity Bought", "Purchase Price", "Total"]] +
    @purchase_order.purchase_line_items.map do |item|
      [item.product_description.name, item.units_purchased, price(item.price), price((item.units_purchased * item.price).round(2))]
    end # creates a 2-dimensional array (ie. each array forms a row)
  end

  def price(num)
    @view.number_to_currency(num)
  end

  def total_price
    move_down 15
    text "Total Bought: #{price(@purchase_order.purchase_line_items.map {|item| item.units_purchased * item.price }.reduce(:+))}", size: 12, style: :bold
  end
end