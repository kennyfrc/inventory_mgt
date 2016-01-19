# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ProductCategory.delete_all
ProductDescription.delete_all
Supplier.delete_all
Customer.delete_all
PurchaseOrder.delete_all
SalesOrder.delete_all
PurchaseLineItem.delete_all
SalesLineItem.delete_all

ProductCategory.create category: "fruits"
product_categories = ProductCategory.all

Supplier.create company_name: "Atom Company"
Supplier.create company_name: "Sublime Company"
Supplier.create company_name: "Emacs Company"
suppliers = Supplier.all

Customer.create company_name: "Chrome Store"
Customer.create company_name: "Firefox Store"
Customer.create company_name: "Opera Store"
customers = Customer.all

ProductDescription.create name: "Banana", sku: "0001", initial_stock_level: 50, product_category: product_categories.find_by( category: "fruits" )
ProductDescription.create name: "Apple", sku: "0002", initial_stock_level: 40, product_category: product_categories.find_by( category: "fruits" )
product_descriptions = ProductDescription.all

PurchaseOrder.create po_number: "PO001", created_at: DateTime.now - 5.days, supplier: suppliers.find_by(company_name: "Atom Company")
PurchaseOrder.create po_number: "PO002", created_at: DateTime.now - 3.days, supplier: suppliers.find_by(company_name: "Sublime Company")
PurchaseOrder.create po_number: "PO003", created_at: DateTime.now - 1.days, supplier: suppliers.find_by(company_name: "Emacs Company")
purchase_orders = PurchaseOrder.all

SalesOrder.create so_number: "SO001", created_at: DateTime.now - 4.days, customer: customers.find_by(company_name: "Chrome Store")
SalesOrder.create so_number: "SO002", created_at: DateTime.now - 2.days, customer: customers.find_by(company_name: "Firefox Store")
SalesOrder.create so_number: "SO003", created_at: DateTime.now, customer: customers.find_by(company_name: "Opera Store")
sales_orders = SalesOrder.all

# purchased bananas and apples from atom company (PO001)
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO001"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 4999, units_purchased: 10
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO001"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 2999, units_purchased: 10

# purchased bananas and apples from sublime company (PO002)
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO002"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 4999, units_purchased: 35
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO002"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 2999, units_purchased: 25

# purchased bananas and apples from emacs company (PO003)
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO003"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 4999, units_purchased: 25
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO003"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 2999, units_purchased: 5
purchases = PurchaseLineItem.all

# sold bananas and apples to chrome store (SO001)
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO001"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 6999, units_sold: 10
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO001"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 3999, units_sold: 10

# sold bananas and apples to firefox store (SO001)
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO002"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 6999, units_sold: 25
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO002"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 3999, units_sold: 5

# sold bananas and apples to opera store (SO003)
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO003"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 6999, units_sold: 20
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO003"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 3999, units_sold: 1
sales = SalesLineItem.all

# patterns
# to get all apples purchased:
# purchases.where(product_description: product_descriptions.find_by(name: "Apple"))
