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

ActiveRecord::Schema.define(version: 20150102200433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointment_categories", force: true do |t|
    t.integer  "lesson_minutes"
    t.integer  "buffer_minutes"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", force: true do |t|
    t.integer  "instructor_id"
    t.integer  "user_id"
    t.integer  "appointment_category_id"
    t.datetime "start_time"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "end_time"
    t.integer  "availability_id"
    t.boolean  "re_bookable",             default: false
    t.string   "stripe_charge_id"
    t.datetime "paid_at"
  end

  create_table "availabilities", force: true do |t|
    t.integer  "instructor_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id"
    t.integer  "appointment_id"
    t.string   "context"
    t.text     "notes"
    t.boolean  "anonymous",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lesson_materials", force: true do |t|
    t.integer  "instructor_id"
    t.string   "name"
    t.text     "description"
    t.string   "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "attachment_processing", default: false, null: false
  end

  create_table "rebookings", force: true do |t|
    t.integer  "old_appointment_id"
    t.integer  "new_appointment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_materials", force: true do |t|
    t.integer  "user_id"
    t.integer  "lesson_material_id"
    t.text     "instructor_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "student_notes"
  end

  create_table "users", force: true do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",                               null: false
    t.string   "last_name"
    t.string   "gender"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.integer  "age"
    t.string   "skill_level"
    t.string   "musical_genre"
    t.string   "years_playing"
    t.boolean  "admin",                    default: false
    t.boolean  "instructor",               default: false
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "guest",                    default: false
    t.string   "stripe_id"
    t.boolean  "accepts_age_agreement",    default: false
    t.string   "profile_photo"
    t.boolean  "profile_photo_processing", default: false, null: false
    t.datetime "deleted_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
