module Muxer
  class Multiplexer
    attr_reader :requests
    def initialize
      @requests = []
      @timeout = nil
    end

    def add_url(url, timeout = nil)
      request = Request.new
      request.url = url
      request.timeout = timeout if timeout
      requests << request
    end

    def execute
      @responses = {succeeded: [], failed: [], pending: []}
      @finish = Time.now + @timeout if @timeout
      EventMachine.run do
        requests.each do |request|
          @responses[:pending] << request.process!
        end

        EM::PeriodicTimer.new(0.01) do
          process_requests
        end
      end
      @responses
    end

    private

    def process_requests
      process_pending
      
      process_timeouts

      if @responses[:pending].empty?
        EM.stop
      end
    end

    def process_pending
      @responses[:pending].each do |pending|
        if pending.completed?
          @responses[:pending].delete(pending)
          if pending.error.nil?
            @responses[:succeeded] << pending
          else
            @responses[:failed] << pending
          end
        end
      end
    end

    def process_timeouts
      if @timeout && Time.now >= finish
        @responses[:pending].each do |pending|
          @responses[:failed] << pending
        end
        @responses[:pending] = []
        EM.stop
      end
    end
  end
end