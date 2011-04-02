class LimitsController < ApplicationController
  active_scaffold :limits do | config |
    config.columns = [:name]
  end
end
