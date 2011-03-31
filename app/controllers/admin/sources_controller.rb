class Admin::SourcesController < ApplicationController
  active_scaffold :source do |config|
    config.label = "Testing Laboratories"
    config.columns = [:name]
    list.columns.exclude :id
    list.sorting = {:name => 'ASC'}
  end
end
