# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_frids-backend-webapp_session',
  :secret      => 'c6b9d706382216c72ec68385ffb76623ddbdec2dab750dae5af6c3fa6d853d66ec03165738186722234e638a1ba5729b19e3841dd2d2034fa790c11759efa954'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
