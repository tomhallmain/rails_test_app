# Add the builds directory to asset paths
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")

# Tell cssbundling-rails to use yarn for asset bundling
ENV["JAVASCRIPT_BUNDLER"] = "yarn" 