class LimitsController < ApplicationController
  active_scaffold :limits do | config |
    config.list.always_show_search = false
    config.actions.exclude  :search    
    config.columns = :name, :field
  end
end
