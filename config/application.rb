require File.expand_path('../boot', __FILE__)

require "sprockets/railtie"
require "action_mailer/railtie"
require "active_model/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module MemcacheStoreErrorApp
  class Application < Rails::Application
  end
end
