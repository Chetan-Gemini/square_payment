require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SquarePayment
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.paths.add File.join('app', 'services'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'services', '*')]
    
    error_msg = "\n\n#{'*'*110}\n\n**** Fatal config error: Set your required env vars, or '.env' file. (See README.rdoc and '.env')\n\n#{'*'*110}\n"
    raise error_msg unless Rails.application.secrets.square_application_id.present? && Rails.application.secrets.square_access_token.present?
  end
end
