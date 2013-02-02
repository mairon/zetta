# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_g_session',
  :secret      => '631a3b7cb9902bdc321a46c3f1cd90bb5cd4a1a94f597a8ed5ac7c6b9c8c705ab53a83bf5d788ebd270d8f65a343d5a81ee3d84521ad978696f8bbb2b606cfd6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
