# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Prevent initializing the application before assets are precompiled (required for heroku)
# config.assets.initialize_on_precompile = false
# Add Rails Admin assets (required)
Rails.application.config.assets.precompile += ['rails_admin/rails_admin.css', 'rails_admin/rails_admin.js']