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

ActiveRecord::Schema.define(:version => 20110722060518) do

  create_table "departments", :force => true do |t|
    t.string "name"
  end

  create_table "fields", :force => true do |t|
    t.string  "name"
    t.boolean "is_required"
    t.integer "parent_id"
    t.string  "type"
    t.boolean "is_multi"
    t.string  "par_hi_lim"
    t.string  "par_lo_lim"
    t.string  "unit_label"
    t.integer "position"
    t.string  "display_as"
    t.integer "group_id"
  end

  add_index "fields", ["group_id"], :name => "index_fields_on_group_id"
  add_index "fields", ["parent_id"], :name => "index_fields_on_parent_id"

  create_table "groups", :force => true do |t|
    t.string  "name"
    t.string  "description"
    t.integer "position"
    t.integer "template_id"
  end

  add_index "groups", ["template_id"], :name => "index_groups_on_template_id"

  create_table "limits", :force => true do |t|
    t.string  "name"
    t.integer "field_id"
    t.boolean "is_default"
    t.integer "position"
  end

  add_index "limits", ["field_id"], :name => "index_limits_on_field_id"

  create_table "links", :force => true do |t|
    t.integer "ancestor_id"
    t.integer "descendant_id"
  end

  add_index "links", ["ancestor_id"], :name => "index_links_on_ancestor_id"
  add_index "links", ["descendant_id"], :name => "index_links_on_descendant_id"

  create_table "patients", :force => true do |t|
    t.string  "name"
    t.string  "rn"
    t.text    "location"
    t.string  "gender"
    t.date    "birthdate"
    t.string  "ethnicity"
    t.integer "height"
    t.float   "weight"
  end

  add_index "patients", ["birthdate"], :name => "index_patients_on_birthdate"
  add_index "patients", ["ethnicity"], :name => "index_patients_on_ethnicity"
  add_index "patients", ["gender"], :name => "index_patients_on_gender"
  add_index "patients", ["name"], :name => "index_patients_on_name"
  add_index "patients", ["rn"], :name => "index_patients_on_rn"

  create_table "sessions", :force => true do |t|
    t.string "session_id", :null => false
    t.text   "data"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "sources", :force => true do |t|
    t.string "name"
  end

  create_table "staffs", :force => true do |t|
    t.string "name"
  end

  add_index "staffs", ["name"], :name => "index_staffs_on_name"

  create_table "templates", :force => true do |t|
    t.string  "name"
    t.boolean "is_active"
    t.string  "colour"
    t.text    "description"
  end

  create_table "testableitems", :force => true do |t|
    t.integer "testable_id"
    t.string  "value"
    t.string  "name"
    t.string  "label"
    t.string  "datatype"
  end

  add_index "testableitems", ["name"], :name => "index_testableitems_on_name"
  add_index "testableitems", ["testable_id"], :name => "index_testableitems_on_testable_id"

  create_table "testables", :force => true do |t|
    t.integer  "linked_test_id"
    t.integer  "patient_id"
    t.integer  "staff_id"
    t.integer  "source_id"
    t.integer  "department_id"
    t.string   "datatype"
    t.datetime "time_in"
    t.datetime "time_out"
  end

  add_index "testables", ["datatype"], :name => "index_testables_on_datatype"
  add_index "testables", ["department_id"], :name => "index_testables_on_department_id"
  add_index "testables", ["linked_test_id"], :name => "index_testables_on_linked_test_id"
  add_index "testables", ["patient_id"], :name => "index_testables_on_patient_id"
  add_index "testables", ["source_id"], :name => "index_testables_on_source_id"
  add_index "testables", ["staff_id"], :name => "index_testables_on_staff_id"
  add_index "testables", ["time_in"], :name => "index_testables_on_time_in"

end
