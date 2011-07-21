class AddIndexesToVarious < ActiveRecord::Migration
  def self.up
    # general performance
    add_index :staffs, :name
    add_index :patients, :name
    add_index :patients, :gender
    add_index :patients, :rn
    add_index :patients, :ethnicity
    add_index :patients, :birthdate

    #foreign keys
    add_index :fields, :parent_id
    add_index :fields, :group_id
    add_index :groups, :template_id
    add_index :limits, :field_id
    add_index :links, :ancestor_id
    add_index :links, :descendant_id
    add_index :testableitems, :testable_id
    add_index :testables, :linked_test_id
    add_index :testables, :patient_id
    add_index :testables, :staff_id
    add_index :testables, :source_id
    add_index :testables, :department_id
  end

  def self.down
    # general performance
    remove_index :staffs, :name
    remove_index :patients, :name
    remove_index :patients, :gender
    remove_index :patients, :rn
    remove_index :patients, :ethnicity
    remove_index :patients, :birthdate

    #foreign keys
    remove_index :fields, :parent_id
    remove_index :fields, :group_id
    remove_index :groups, :template_id
    remove_index :limits, :field_id
    remove_index :links, :ancestor_id
    remove_index :links, :descendant_id
    remove_index :testableitems, :testable_id
    remove_index :testables, :linked_test_id
    remove_index :testables, :patient_id
    remove_index :testables, :staff_id
    remove_index :testables, :source_id
    remove_index :testables, :department_id
  end
end

