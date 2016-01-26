class SoPdf < Prawn::Document
  def initialize(sales_order, view)
    super(top_margin: 70)
          # Ruby's super method lets us call a method in the parent class from within the child class.
          # we can also pass some stuff here as much as we pass stuff to Prawn::Document like top_margin
    @sales_order = sales_order # because this is a new class, we don't have access to the instance variable.. so we need to pass it pa
    @view = view
    bill_to
    sales_order_number
    line_items
    total_price
  end

  def bill_to
    text "Billed To: #{@sales_order.customer.company_name}", size: 12, style: :bold 
    text "Address: #{@sales_order.customer.address}", size: 10
    text "#{@sales_order.customer.city}, #{@sales_order.customer.region}", size: 10
    text "#{@sales_order.customer.country}", size: 10
  end

  def sales_order_number
    text "Sales Order \##{@sales_order.so_number}", size: 10
  end

  def line_items
    move_down 20 # will be shown 20 lines below the sales_order number
    table line_item_rows
  end

  def line_item_rows
    [["Product Name", "Quantity Sold", "Retail Price", "Total"]] +
    @sales_order.sales_line_items.map do |item|
      [item.product_description.name, item.units_sold, price(item.price), price((item.units_sold * item.price).round(2))]
    end # creates a 2-dimensional array (ie. each array forms a row)
  end

  def price(num)
    @view.number_to_currency(num)
  end

  def total_price
    move_down 15
    text "Total Billed: #{price(@sales_order.sales_line_items.map {|item| item.units_sold * item.price }.reduce(:+))}", size: 12, style: :bold
  end
end