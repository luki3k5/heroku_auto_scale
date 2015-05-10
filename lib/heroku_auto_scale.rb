require "heroku_auto_scale/version"
require "heroku_auto_scale/manager"
require "heroku_auto_scale/configuration"

module HerokuAutoScale
  extend Configuration

  class << self
    def included(includer)
      includer.send("include", Methods)
      includer.extend(Methods)
    end

    def manager
      @manager ||= Manager.new
    end
  end

  module Methods

    def heroku_observe
      yield
      manage_queue
    end

    def process_name(process_name)
      HerokuAutoScale.manager.set_process_name(process_name)
    end

    def queue_name(queue_name)
      HerokuAutoScale.manager.set_queue_name(queue_name)
    end

    def scaling_step(step)
      HerokuAutoScale.manager.set_scaling_step(step)
    end

    def max_dynos(number_of_dynos)
      HerokuAutoScale.manager.set_max_dynos(number_of_dynos)
    end

    def min_dynos(number_of_dynos)
      HerokuAutoScale.manager.set_min_dynos(number_of_dynos)
    end

    def manage_queue
      HerokuAutoScale.manager.manage_queue
    end
  end

  extend Methods
end
