# Be sure to restart your server when you modify this file.

# Project101::Application.config.session_store :cookie_store, :key => '_project101_session', :domain => :all

# Disabled :domain => :all because after 3.0.20 from 3.0.3 upgrade, :cookie_store is broken if 
#    Subdomain is not specifically set in URL
Project101::Application.config.session_store :cookie_store, :key => '_autoins_app_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Project101::Application.config.session_store :active_record_store
