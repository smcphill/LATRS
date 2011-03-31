class Admin::DepartmentsController < ApplicationController
  active_scaffold :department do |config|
    config.label = "Departments"
    config.columns = [:name]
    list.columns.exclude :id
    list.sorting = {:name => 'ASC'}
  end
end
