class Admin::TestersController < ApplicationController
  active_scaffold :tester do |config|
    config.label = "MTC Lab Testers"
    config.columns = [:name]
    list.columns.exclude :id
    list.sorting = {:name => 'ASC'}
  end
end
