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
User.delete_all

admin = User.new(
   email:    'admin@example.com',
   password: 'helloworld',
 )
 admin.skip_confirmation!
 admin.save!
 users = User.all

ProductCategory.create category: "fruits"
product_categories = ProductCategory.all

Supplier.create company_name: "Atom Company", user: User.find(1)
Supplier.create company_name: "Sublime Company", user: User.find(1)
Supplier.create company_name: "Emacs Company", user: User.find(1)
suppliers = Supplier.all

Customer.create company_name: "Chrome Store", user: User.find(1)
Customer.create company_name: "Firefox Store", user: User.find(1)
Customer.create company_name: "Opera Store", user: User.find(1)
customers = Customer.all

ProductDescription.create name: "Banana", sku: "0001", def_retail_price_in_cents: 6999, def_wholesale_price_in_cents: 5999, def_purchase_price_in_cents: 4999,initial_stock_level: 50, initial_units_sold: 20, initial_units_purchased: 30, product_category: product_categories.find_by( category: "fruits" ), user: User.find(1)
ProductDescription.create name: "Apple", sku: "0002", def_retail_price_in_cents: 3999, def_wholesale_price_in_cents: 3499, def_purchase_price_in_cents: 2999,initial_stock_level: 40, initial_units_sold: 20, initial_units_purchased: 30, product_category: product_categories.find_by( category: "fruits" ), user: User.find(1)
product_descriptions = ProductDescription.all

PurchaseOrder.create po_number: "PO001", created_at: DateTime.now - 5.days, supplier: suppliers.find_by(company_name: "Atom Company"), user: User.find(1)
PurchaseOrder.create po_number: "PO002", created_at: DateTime.now - 3.days, supplier: suppliers.find_by(company_name: "Sublime Company"), user: User.find(1)
PurchaseOrder.create po_number: "PO003", created_at: DateTime.now - 1.days, supplier: suppliers.find_by(company_name: "Emacs Company"), user: User.find(1)
purchase_orders = PurchaseOrder.all

SalesOrder.create so_number: "SO001", created_at: DateTime.now - 4.days, customer: customers.find_by(company_name: "Chrome Store"), user: User.find(1)
SalesOrder.create so_number: "SO002", created_at: DateTime.now - 2.days, customer: customers.find_by(company_name: "Firefox Store"), user: User.find(1)
SalesOrder.create so_number: "SO003", created_at: DateTime.now, customer: customers.find_by(company_name: "Opera Store"), user: User.find(1)
sales_orders = SalesOrder.all

# purchased bananas and apples from atom company (PO001)
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO001"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 4999, units_purchased: 10, created_at: purchase_orders.where(po_number: "PO001").pluck(:created_at)[0]
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO001"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 2999, units_purchased: 10, created_at: purchase_orders.where(po_number: "PO001").pluck(:created_at)[0]

# purchased bananas and apples from sublime company (PO002)
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO002"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 4999, units_purchased: 35, created_at: purchase_orders.where(po_number: "PO002").pluck(:created_at)[0]
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO002"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 2999, units_purchased: 25, created_at: purchase_orders.where(po_number: "PO002").pluck(:created_at)[0]

# purchased bananas and apples from emacs company (PO003)
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO003"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 4999, units_purchased: 25, created_at: purchase_orders.where(po_number: "PO003").pluck(:created_at)[0]
PurchaseLineItem.create purchase_order: purchase_orders.find_by(po_number: "PO003"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 2999, units_purchased: 5, created_at: purchase_orders.where(po_number: "PO003").pluck(:created_at)[0]
purchases = PurchaseLineItem.all

# sold bananas and apples to chrome store (SO001)
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO001"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 6999, units_sold: 10, created_at: sales_orders.where(so_number: "SO001").pluck(:created_at)[0]
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO001"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 3999, units_sold: 10, created_at: sales_orders.where(so_number: "SO001").pluck(:created_at)[0] # it starts with an array.. easy way to retrieve the element, which is a ActiveSupport::DateTimeZone type

# sold bananas and apples to firefox store (SO002)
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO002"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 6999, units_sold: 25, created_at: sales_orders.where(so_number: "SO002").pluck(:created_at)[0]
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO002"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 3999, units_sold: 5, created_at: sales_orders.where(so_number: "SO002").pluck(:created_at)[0]

# sold bananas and apples to opera store (SO003)
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO003"), product_description: product_descriptions.find_by(name: "Banana"), price_in_cents: 6999, units_sold: 20, created_at: sales_orders.where(so_number: "SO003").pluck(:created_at)[0]
SalesLineItem.create sales_order: sales_orders.find_by(so_number: "SO003"), product_description: product_descriptions.find_by(name: "Apple"), price_in_cents: 3999, units_sold: 1, created_at: sales_orders.where(so_number: "SO003").pluck(:created_at)[0]
sales = SalesLineItem.all

# patterns
# to get all apples purchased:
# purchases.where(product_description: product_descriptions.find_by(name: "Apple"))
