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

ActiveRecord::Schema.define(version: 2018_07_01_223826) do

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "plain", null: false
    t.string "type", default: "current", null: false
    t.integer "user_id", null: false
    t.integer "currency_id", null: false
    t.index ["currency_id"], name: "index_accounts_on_currency_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "balance_bases", force: :cascade do |t|
    t.string "timeperiod_type"
    t.integer "timeperiod_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.integer "currency_id", null: false
    t.decimal "value", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", null: false
    t.string "type", null: false
    t.string "transaction_type"
    t.index ["currency_id"], name: "index_balance_bases_on_currency_id"
    t.index ["id", "type"], name: "index_balance_bases_on_id_and_type"
    t.index ["owner_type", "owner_id"], name: "index_balance_bases_on_owner_type_and_owner_id"
    t.index ["timeperiod_type", "timeperiod_id"], name: "index_balance_bases_on_timeperiod_type_and_timeperiod_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_account_id"
    t.integer "currency_id", null: false
    t.string "comment"
    t.boolean "active", default: true, null: false
    t.index ["currency_id"], name: "index_budgets_on_currency_id"
    t.index ["default_account_id"], name: "index_budgets_on_default_account_id"
    t.index ["user_id"], name: "index_budgets_on_user_id"
  end

  create_table "budgets_targets", id: false, force: :cascade do |t|
    t.integer "target_id", null: false
    t.integer "budget_id", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_currencies_on_user_id"
  end

  create_table "periods", force: :cascade do |t|
    t.integer "budget_id", null: false
    t.string "comment"
    t.date "start_date", null: false
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["budget_id"], name: "index_periods_on_budget_id"
    t.index ["user_id"], name: "index_periods_on_user_id"
  end

  create_table "targets", force: :cascade do |t|
    t.string "name", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "default_income_transaction_category_id"
    t.integer "default_expense_transaction_category_id"
    t.boolean "favourite", default: false
    t.index ["default_expense_transaction_category_id"], name: "index_targets_on_default_expense_transaction_category_id"
    t.index ["default_income_transaction_category_id"], name: "index_targets_on_default_income_transaction_category_id"
    t.index ["user_id"], name: "index_targets_on_user_id"
  end

  create_table "transaction_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "comment"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transaction_categories_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "period_id", null: false
    t.integer "transaction_category_id", null: false
    t.decimal "currency_rate", default: "1.0", null: false
    t.string "comment"
    t.decimal "value", precision: 8, scale: 2, null: false
    t.string "source_type"
    t.integer "source_id"
    t.string "destination_type"
    t.integer "destination_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", null: false
    t.integer "budget_id"
    t.integer "user_id"
    t.integer "source_currency_id"
    t.integer "destination_currency_id"
    t.string "type", null: false
    t.index ["budget_id"], name: "index_transactions_on_budget_id"
    t.index ["destination_currency_id"], name: "index_transactions_on_destination_currency_id"
    t.index ["destination_type", "destination_id"], name: "index_transactions_on_destination_type_and_destination_id"
    t.index ["period_id"], name: "index_transactions_on_period_id"
    t.index ["source_currency_id"], name: "index_transactions_on_source_currency_id"
    t.index ["source_type", "source_id"], name: "index_transactions_on_source_type_and_source_id"
    t.index ["transaction_category_id"], name: "index_transactions_on_transaction_category_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 1073741823
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
