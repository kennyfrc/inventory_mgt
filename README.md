##### Context:

I've tried a lot of inventory management applications but all of them don't accomplish why supply chain managers want an inventory management software to begin with, which is to solve either a) a low stock problem (leading to lost revenue) or b) a high stock problem (leading to the sunk cost problem). Such need requires a metric called "Days on Hand" which equips the user with the knowledge on when s/he needs to restock and how much he needs to push demand. Hence, the creation of this application.


##### Current Feature List (Jan 27, 2016):

 * Graph Profit, Sales, and Costs (Overall)
 * Graph Stock Level (Overall) 
 * Graph Days on Hand (Overall) 
 * By-SKU Search and view of profit, sales, costs, DoH, and stock levels
 * Generate a Sales and Purchase Order PDF 
 * Email said PDF to either your supplier or customer

##### To Do List:

 * !!! Fix painful Google Charts issue in Heroku.
 * Import / Export to and from CSV
 * Multitenancy 
 * Billing via Braintree (Stripe not available in my country)
 * Data binding in Purchase Orders and Sales Orders
 * Update / Destroy functionality for Products, Sales Orders, Purchase Orders, Suppliers, and Customers


 ##### Domain Model:

 ![](https://github.com/kennyfrc/inventory_mgt/blob/master/lib/assets/img/domain_model.jpg)