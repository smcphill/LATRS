# Settings specified here will take precedence over those in config/environment.rb

# mysql-specific SQL fragments
DB_TNUMVALS_SEARCH = "format(testableitems.value, 2)"
DB_TIME_TAKEN_SEARCH = "TIMESTAMPDIFF(MINUTE,time_in,time_out)"
DB_TIME_TAKEN_SORT = "TIMESTAMPDIFF(MINUTE,time_in,time_out)"
DB_PATIENT_AGE_SEARCH = "TIMESTAMPDIFF(YEAR,birthdate,curdate()) as years"

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
