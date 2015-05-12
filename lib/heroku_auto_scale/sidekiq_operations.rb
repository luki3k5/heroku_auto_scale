require 'sidekiq/api'

module HerokuAutoScale
  class SidekiqOperations
    attr_accessor :queue

    def check_queue_for_jobs(queue_name)
      @queue = Sidekiq::Queue.new(queue_name)
      @queue.size
    end

  end
end
