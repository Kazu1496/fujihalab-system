require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InAnyoneLab
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.middleware.use Rack::Attack

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    Rack::Attack.safelist('allow from whitelist') do |req|
      req.path == '/api/v1/existence' && '127.0.0.1' == req.ip || ENV['LAB_IP_ADDRESS'] == req.ip
    end
  end
end


