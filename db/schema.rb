# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_12_095857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credibility_details", force: :cascade do |t|
    t.bigint "credit_limit"
    t.bigint "max_possible_emi"
    t.bigint "term_in_months"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "credibility_score", default: 0
    t.string "eligibility_status"
    t.boolean "approved_user"
    t.index ["user_id"], name: "index_credibility_details_on_user_id"
  end

  create_table "user_acc_details", force: :cascade do |t|
    t.bigint "account_number"
    t.string "ifsc"
    t.bigint "inflow"
    t.bigint "outflow"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_acc_details_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "pan_card_no"
    t.bigint "aadhar_card_no"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "credibility_details", "users"
  add_foreign_key "user_acc_details", "users"
end
