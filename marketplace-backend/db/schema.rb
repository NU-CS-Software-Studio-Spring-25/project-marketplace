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

ActiveRecord::Schema[8.0].define(version: 2025_05_27_010849) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "course_prerequisites", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "prerequisite_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_prerequisites_on_course_id"
    t.index ["prerequisite_id"], name: "index_course_prerequisites_on_prerequisite_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_number"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_number"], name: "index_courses_on_course_number", unique: true
  end

  create_table "courses_instructors", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "instructor_id", null: false
    t.index ["course_id", "instructor_id"], name: "index_courses_instructors_on_course_id_and_instructor_id"
    t.index ["instructor_id", "course_id"], name: "index_courses_instructors_on_instructor_id_and_course_id"
  end

  create_table "courses_labels", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "label_id", null: false
    t.index ["course_id", "label_id"], name: "index_courses_labels_on_course_id_and_label_id"
    t.index ["label_id", "course_id"], name: "index_courses_labels_on_label_id_and_course_id"
  end

  create_table "courses_quarters", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "quarter_id", null: false
    t.index ["course_id", "quarter_id"], name: "index_courses_quarters_on_course_id_and_quarter_id"
    t.index ["quarter_id", "course_id"], name: "index_courses_quarters_on_quarter_id_and_course_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "display_name"
    t.index ["name"], name: "index_labels_on_name", unique: true
  end

  create_table "quarters", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
  end

  add_foreign_key "course_prerequisites", "courses"
  add_foreign_key "course_prerequisites", "courses", column: "prerequisite_id"
  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
end
