require 'heroku_auto_scale/redis_operations'
require 'heroku_auto_scale'
require 'heroku_auto_scale/configuration'
require 'heroku_auto_scale/heroku_operations'
require 'heroku_auto_scale/sidekiq_operations'

module HerokuAutoScale
  class Manager
    MNGR_ATTRIBUTES = [
      :process_name,
      :queue_name,
      :sidekiq_operations,
      :heroku_operations,
      :min_dynos,
      :max_dynos,
      :scaling_step
    ].freeze

    attr_accessor *HerokuAutoScale::Configuration::CONFIGURATION_OPTIONS
    attr_accessor *MNGR_ATTRIBUTES

    def initialize(options={})
      options = HerokuAutoScale.options.merge(options)
      Configuration::CONFIGURATION_OPTIONS.each do |key|
        send("#{key}=", options[key])
      end

      #init_redis_operations
      init_sidekiq_operations
      init_heroku_operations
    end

    def get_number_of_jobs_inside_queue
      sidekiq_operations.check_queue_for_jobs(@queue_name)
      #redis_operations.check_queue_for_jobs(@queue_name)
    end

    def set_process_name(process_name)
      @process_name = process_name
    end

    def set_queue_name(queue_name)
      @queue_name = queue_name
    end

    def set_min_dynos(min_dynos)
      @min_dynos = min_dynos
    end

    def set_max_dynos(max_dynos)
      @max_dynos = max_dynos
    end

    def set_scaling_step(scaling_step)
      @scaling_step = scaling_step
    end

    def manage_queue
      scale_to = calculate_number_of_needed_dynos
      heroku_operations.execute_dyno_scale(process_name, scale_to)
    end

    def calculate_number_of_needed_dynos
      current_jobs = get_number_of_jobs_inside_queue
      dynos = (current_jobs.to_f / scaling_step.to_f).ceil

      scale_to = [dynos, max_dynos].min
      scale_to = [scale_to, min_dynos].max
    end

    private
      #def init_redis_operations
        #@redis_operations = HerokuAutoScale::RedisOperations.new(redis_url)
      #end
      def init_sidekiq_operations
        @sidekiq_operations ||= HerokuAutoScale::
          SidekiqOperations.new
      end

      def init_heroku_operations
        @heroku_operations ||= HerokuAutoScale::
          HerokuOperations.new(
            heroku_oauth_token,
            heroku_app_name
        )
      end
  end
end
