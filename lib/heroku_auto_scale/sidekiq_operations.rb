require 'sidekiq/api'

module HerokuAutoScale
  class SidekiqOperations
    attr_accessor :queue

    def check_queue_for_jobs(queue_name)
      @queue = Sidekiq::Queue.new(queue_name)
      @queue.size
    end

    def check_processes_running(process_name)
      ps = Sidekiq::ProcessSet.new
      process = ps.find { |p| p['hostname'].includes?(process_name) }
      process['busy']
    end

  end
end
