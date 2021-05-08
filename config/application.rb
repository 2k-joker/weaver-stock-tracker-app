require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WeaverStockTrackerApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Custom directories with classes and modules you want to be autoloadable and eager-loaded.
    config.eager_load_paths += ["#{config.root}/lib"]

    # Use sidekiq as jobs backend
    # config.active_job.queue_adapter = :sidekiq

    # Set job queue name prefix
    # config.active_job.queue_name_prefix = Rails.env

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
