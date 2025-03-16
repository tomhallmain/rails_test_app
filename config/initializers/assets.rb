# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

Rails.application.config.assets.paths << Rails.root.join("node_modules")
Rails.application.config.assets.paths << Rails.root.join('app/assets/javascripts')
Rails.application.config.assets.paths << Rails.root.join('app/assets/stylesheets')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/javascripts')
Rails.application.config.assets.paths << Rails.root.join('vendor/assets/stylesheets')

# Add RailsAdmin Engine assets
Rails.application.config.assets.paths << Rails.root.join('C:/Ruby33-x64/lib/ruby/gems/3.3.0/gems/rails_admin-3.3.0/app/assets/stylesheets')
Rails.application.config.assets.paths << Rails.root.join('C:/Ruby33-x64/lib/ruby/gems/3.3.0/gems/rails_admin-3.3.0/app/assets/javascripts')
Rails.application.config.assets.paths << Rails.root.join('C:/Ruby33-x64/lib/ruby/gems/3.3.0/gems/rails_admin-3.3.0/vendor/assets/fonts')

# Precompile additional assets
Rails.application.config.assets.precompile += %w( rails_admin.css rails_admin.js )

# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join("node_modules/@fortawesome/fontawesome-free/webfonts")
