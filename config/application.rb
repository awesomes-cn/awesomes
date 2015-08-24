require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webs
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    #local env
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end
    
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = 'zh-CN'
    config.active_record.raise_in_transactional_callbacks = true

   
    config.source_access_path = ENV['SOURCE_ACCESS_PATH']

  end
end



#补丁
class ActiveSupport::TimeWithZone
    def friendly
        require 'time_diff'
        Time.diff(self, Time.new).each do |k,v|
            return [v,k] if v > 0
        end
        [0, 'second']
    end

    def friendly_i18n
        _diff = friendly
        if _diff[1] == 'sec'
          I18n.t('justnow')
        else

          "#{_diff[0]}#{I18n.t(_diff[1])}#{I18n.t('ago')}"
        end
    end
end
