require 'redis'

module HerokuAutoScale
  class RedisOperations
    attr_reader :redis_connection

    def initialize(url)
      @redis_connection = Redis.new(url: url)
    end

    def check_queue_for_jobs(queue_name)
      check_queue(queue_name)
      redis_connection.llen(queue_name)
    end

    private
      def check_queue(queue_name)
        available_keys = redis_connection.keys
        unless available_keys.include?(queue_name)
          raise "There is no key #{queue_name}, \n
                 available keys are:\n
                 #{available_keys}"
        end
      end
  end
end
