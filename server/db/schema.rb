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

ActiveRecord::Schema.define(version: 20171022204931) do

  create_table "dishes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "meal_id"
  end

  add_index "dishes", ["meal_id"], name: "index_dishes_on_meal_id"

  create_table "meals", force: :cascade do |t|
    t.date     "meal_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "period_id",     null: false
    t.integer  "university_id", null: false
  end

  add_index "meals", ["period_id"], name: "index_meals_on_period_id"
  add_index "meals", ["university_id"], name: "index_meals_on_university_id"

  create_table "periods", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "universities", force: :cascade do |t|
    t.string   "name"
    t.string   "long_name"
    t.string   "class_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "university_id"
    t.text     "website"
  end

  add_index "universities", ["name"], name: "index_universities_on_name", unique: true
  add_index "universities", ["university_id"], name: "index_universities_on_university_id"

end
