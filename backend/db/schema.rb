# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_27_093938) do

  create_table "line_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "line_id", null: false
    t.string "notice_time", default: "07:00", null: false
    t.boolean "silent_notice", default: true, null: false
    t.string "auth_token"
    t.string "inherit_token"
    t.datetime "located_at"
    t.datetime "locating_from"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["auth_token"], name: "index_line_users_on_auth_token", unique: true
    t.index ["inherit_token"], name: "index_line_users_on_inherit_token", unique: true
    t.index ["line_id"], name: "index_line_users_on_line_id", unique: true
    t.index ["user_id"], name: "index_line_users_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "weathers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "line_user_id"
    t.string "city"
    t.decimal "lat", precision: 5, scale: 2
    t.decimal "lon", precision: 5, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["line_user_id"], name: "index_weathers_on_line_user_id"
  end

end
