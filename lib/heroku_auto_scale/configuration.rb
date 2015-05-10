module HerokuAutoScale
  module Configuration
    CONFIGURATION_OPTIONS = [
      :redis_url,
      :heroku_oauth_token,
      :heroku_app_name
    ].freeze

    attr_accessor *CONFIGURATION_OPTIONS

    def configure
      yield self
    end

    def options
      CONFIGURATION_OPTIONS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end
  end
end
