require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
    end

    config.time_zone = 'Asia/Tokyo'

    config.i18n.default_locale = :ja

    # production環境でのlibディレクトリの読み込みを設定
    config.paths.add 'lib', eager_load: true

    # キューイングバックエンドを設定
    config.active_job.queue_adapter = :sidekiq unless ENV['LIGHT_MODE']

    # メイラープレビューのパスを変更
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    # 多言語対応設定
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.available_locales = %i[ja en]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :ja
  end
end
