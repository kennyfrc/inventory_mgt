# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160119050802) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.text     "address"
    t.string   "city"
    t.string   "company_name"
    t.string   "country"
    t.text     "description"
    t.string   "email"
    t.string   "fax"
    t.string   "phone"
    t.string   "region"
    t.string   "tax_number"
    t.string   "url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_descriptions", force: :cascade do |t|
    t.integer  "def_retail_price_in_cents"
    t.integer  "def_wholesale_price_in_cents"
    t.text     "description"
    t.integer  "initial_cost_in_cents"
    t.integer  "initial_stock_level"
    t.string   "name"
    t.string   "sku"
    t.integer  "product_category_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "product_descriptions", ["product_category_id"], name: "index_product_descriptions_on_product_category_id", using: :btree

  create_table "purchase_line_items", force: :cascade do |t|
    t.integer  "price_in_cents"
    t.integer  "units_purchased"
    t.integer  "purchase_order_id"
    t.integer  "product_description_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "purchase_line_items", ["product_description_id"], name: "index_purchase_line_items_on_product_description_id", using: :btree
  add_index "purchase_line_items", ["purchase_order_id"], name: "index_purchase_line_items_on_purchase_order_id", using: :btree

  create_table "purchase_orders", force: :cascade do |t|
    t.string   "po_number"
    t.integer  "supplier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "purchase_orders", ["supplier_id"], name: "index_purchase_orders_on_supplier_id", using: :btree

  create_table "sales_line_items", force: :cascade do |t|
    t.integer  "price_in_cents"
    t.integer  "units_sold"
    t.integer  "sales_order_id"
    t.integer  "product_description_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sales_line_items", ["product_description_id"], name: "index_sales_line_items_on_product_description_id", using: :btree
  add_index "sales_line_items", ["sales_order_id"], name: "index_sales_line_items_on_sales_order_id", using: :btree

  create_table "sales_orders", force: :cascade do |t|
    t.string   "so_number"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "sales_orders", ["customer_id"], name: "index_sales_orders_on_customer_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.text     "address"
    t.string   "city"
    t.string   "company_name"
    t.string   "country"
    t.text     "description"
    t.string   "email"
    t.string   "fax"
    t.string   "phone"
    t.string   "region"
    t.string   "tax_number"
    t.string   "url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "product_descriptions", "product_categories"
  add_foreign_key "purchase_line_items", "product_descriptions"
  add_foreign_key "purchase_line_items", "purchase_orders"
  add_foreign_key "purchase_orders", "suppliers"
  add_foreign_key "sales_line_items", "product_descriptions"
  add_foreign_key "sales_line_items", "sales_orders"
  add_foreign_key "sales_orders", "customers"
end
