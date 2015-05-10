require 'platform-api'

module HerokuAutoScale
  class HerokuOperations
    attr_reader :heroku_connection, :app_name

    def initialize(api_key, app_name)
      @heroku_connection = PlatformAPI.connect_oauth(api_key)
      @app_name          = app_name
    end

    def execute_dyno_scale(process_name, new_number_of_dynos)
      if should_scale?(process_name, new_number_of_dynos)
        scale_dynos(process_name, new_number_of_dynos)
      end
    end

    private
      def scale_dynos(process_name, new_number_of_dynos)
        heroku_connection.formation.update(
          app_name,
          process_name,
          {"quantity" => new_number_of_dynos}
        )
      end

      def should_scale?(process_name, new_number_of_dynos)
        response = heroku_connection.formation.info(app_name, process_name)
        response["quantity"] != new_number_of_dynos
      end
  end
end
