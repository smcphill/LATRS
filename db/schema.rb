# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110627040350) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", :force => true do |t|
    t.string   "name"
    t.boolean  "is_required"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "type"
    t.boolean  "is_multi"
    t.string   "par_hi_lim"
    t.string   "par_lo_lim"
    t.string   "unit_label"
    t.integer  "position"
    t.string   "display_as"
    t.integer  "group_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "position"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "limits", :force => true do |t|
    t.string   "name"
    t.integer  "field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default"
    t.integer  "position"
  end

  create_table "links", :force => true do |t|
    t.integer  "ancestor_id"
    t.integer  "descendant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", :force => true do |t|
    t.string   "name"
    t.string   "rn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staffs", :force => true do |t|
    t.string "name"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "colour"
    t.text     "description"
  end

  create_table "testableitems", :force => true do |t|
    t.integer  "testable_id"
    t.integer  "field_id"
    t.string   "value_s"
    t.integer  "value_i"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testables", :force => true do |t|
    t.integer  "linked_test_id"
    t.integer  "patient_id"
    t.integer  "staff_id"
    t.integer  "source_id"
    t.integer  "department_id"
    t.string   "type"
    t.datetime "time_in"
    t.datetime "time_out"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
