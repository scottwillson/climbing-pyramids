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

ActiveRecord::Schema.define(version: 2020_04_05_194839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "climbs", force: :cascade do |t|
    t.decimal "grade_decimal", null: false
    t.string "grade_letter", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "discipline_id"
    t.string "mountain_project_tick_id"
    t.date "climbed_on", null: false
    t.string "mountain_project_route_id"
    t.string "name"
    t.integer "mountain_project_pitches"
    t.integer "mountain_project_user_stars"
    t.string "mountain_project_lead_style"
    t.string "mountain_project_notes"
    t.string "mountain_project_style"
    t.string "mountain_project_type"
    t.string "mountain_project_user_rating"
    t.bigint "person_id"
    t.index ["discipline_id"], name: "index_climbs_on_discipline_id"
    t.index ["person_id"], name: "index_climbs_on_person_id"
  end

  create_table "disciplines", force: :cascade do |t|
    t.string "name", default: "Unamed", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "mountain_project_user_id"
    t.index ["confirmation_token"], name: "index_people_on_confirmation_token", unique: true
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true
  end

  create_table "pyramids", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "discipline_id"
    t.decimal "redpoint_grade_decimal"
    t.string "redpoint_grade_letter"
    t.bigint "person_id"
    t.index ["discipline_id"], name: "index_pyramids_on_discipline_id"
    t.index ["person_id"], name: "index_pyramids_on_person_id"
  end

end
