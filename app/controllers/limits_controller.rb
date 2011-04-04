class LimitsController < ApplicationController
  active_scaffold :limits do | config |
    config.columns = :name, :field
  end
end
