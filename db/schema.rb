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

ActiveRecord::Schema[8.0].define(version: 2025_05_02_153939) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "asset_details", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "brand"
    t.string "model"
    t.string "serial_number"
    t.date "assigned_date"
    t.date "returned_date"
    t.string "status", default: "assigned"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_asset_details_on_user_id"
  end

  create_table "attendance_attendances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "attendance_date"
    t.datetime "check_in"
    t.datetime "check_out"
    t.decimal "working_hours", precision: 5, scale: 2
    t.decimal "overtime_hours", precision: 5, scale: 2
    t.string "status"
    t.boolean "payroll_processed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "shift_id"
    t.boolean "late_status", default: false
    t.index ["shift_id"], name: "index_attendance_attendances_on_shift_id"
    t.index ["user_id"], name: "index_attendance_attendances_on_user_id"
  end

  create_table "attendance_shifts", force: :cascade do |t|
    t.string "name"
    t.time "start_time"
    t.time "end_time"
    t.decimal "break_hours", precision: 4, scale: 2, default: "1.0"
    t.boolean "is_rotating", default: false
    t.string "shift_type", default: "Regular"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendance_user_shifts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "shift_id", null: false
    t.date "assigned_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_attendance_user_shifts_on_shift_id"
    t.index ["user_id"], name: "index_attendance_user_shifts_on_user_id"
  end

  create_table "bank_details", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "salary_structure"
    t.string "payment_method"
    t.string "bank_name"
    t.string "bank_account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bank_details_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_employments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "job_title"
    t.string "employment_type"
    t.date "hire_date"
    t.string "work_location"
    t.string "manager_name"
    t.string "job_status"
    t.string "blood_group"
    t.string "employee_service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_job_employments_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_infos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "father_name"
    t.string "national_id"
    t.date "dob"
    t.integer "gender", default: 1
    t.integer "grade", default: 1
    t.string "phone", limit: 11
    t.text "address"
    t.string "personal_number", limit: 11
    t.string "company_number", limit: 11
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "employee_code"
    t.index ["user_id"], name: "index_user_infos_on_user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "active"
    t.bigint "department_id"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "asset_details", "users"
  add_foreign_key "attendance_attendances", "attendance_shifts", column: "shift_id"
  add_foreign_key "attendance_attendances", "users"
  add_foreign_key "attendance_user_shifts", "attendance_shifts", column: "shift_id"
  add_foreign_key "attendance_user_shifts", "users"
  add_foreign_key "bank_details", "users"
  add_foreign_key "job_employments", "users"
  add_foreign_key "user_infos", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "departments"
end
