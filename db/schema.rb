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

ActiveRecord::Schema.define(version: 20160126083724) do

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
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
    t.integer  "mail_for_partner_id"
  end

  add_index "customers", ["mail_for_partner_id"], name: "index_customers_on_mail_for_partner_id", using: :btree
  add_index "customers", ["user_id"], name: "index_customers_on_user_id", using: :btree

  create_table "mail_for_partners", force: :cascade do |t|
    t.string   "email"
    t.string   "subject"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mail_for_partners", ["user_id"], name: "index_mail_for_partners_on_user_id", using: :btree

  create_table "product_categories", force: :cascade do |t|
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_descriptions", force: :cascade do |t|
    t.integer  "def_retail_price_in_cents"
    t.integer  "def_wholesale_price_in_cents"
    t.text     "description"
    t.integer  "def_purchase_price_in_cents"
    t.integer  "initial_stock_level"
    t.integer  "initial_units_sold"
    t.integer  "initial_units_purchased"
    t.string   "name"
    t.string   "sku"
    t.integer  "product_category_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id"
  end

  add_index "product_descriptions", ["product_category_id"], name: "index_product_descriptions_on_product_category_id", using: :btree
  add_index "product_descriptions", ["user_id"], name: "index_product_descriptions_on_user_id", using: :btree

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
    t.integer  "user_id"
  end

  add_index "purchase_orders", ["supplier_id"], name: "index_purchase_orders_on_supplier_id", using: :btree
  add_index "purchase_orders", ["user_id"], name: "index_purchase_orders_on_user_id", using: :btree

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
    t.integer  "user_id"
  end

  add_index "sales_orders", ["customer_id"], name: "index_sales_orders_on_customer_id", using: :btree
  add_index "sales_orders", ["user_id"], name: "index_sales_orders_on_user_id", using: :btree

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
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
    t.integer  "mail_for_partner_id"
  end

  add_index "suppliers", ["mail_for_partner_id"], name: "index_suppliers_on_mail_for_partner_id", using: :btree
  add_index "suppliers", ["user_id"], name: "index_suppliers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "", null: false
    t.string   "encrypted_password",       default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "certificate_file_name"
    t.string   "certificate_content_type"
    t.integer  "certificate_file_size"
    t.datetime "certificate_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "mail_for_partners", "users"
  add_foreign_key "product_descriptions", "product_categories"
  add_foreign_key "purchase_line_items", "product_descriptions"
  add_foreign_key "purchase_line_items", "purchase_orders"
  add_foreign_key "purchase_orders", "suppliers"
  add_foreign_key "sales_line_items", "product_descriptions"
  add_foreign_key "sales_line_items", "sales_orders"
  add_foreign_key "sales_orders", "customers"
end
