require 'ext/mongoid'

module Honeypot
  # The worker class
  class Worker
    def initialize(worker)
      @worker = worker
    end

    def critera
      @worker.critera
    end

    def run
      critera.tailable_diff do |prev, now|
        @worker.notify_if_modified(prev, now)
      end
    end
  end
end
