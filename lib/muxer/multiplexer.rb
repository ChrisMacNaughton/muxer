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
      responses = {succeeded: [], failed: [], pending: []}
      looping = true
      finish = Time.now + @timeout if @timeout
      EventMachine.run do
        requests.each do |request|
          responses[:pending] << request.process!
        end

        EM::PeriodicTimer.new(0.01) do
          responses[:pending].each do |pending|
            # binding.pry
            if pending.completed?
              responses[:pending].delete(pending)
              if pending.error.nil?
                responses[:succeeded] << pending
              else
                responses[:failed] << pending
              end
            end
          end
          if @timeout && Time.now >= finish
            responses[:pending].each do |pending|
              responses[:failed] << pending
            end
            responses[:pending] = []
            EM.stop
          end

          if responses[:pending].empty?
            EM.stop
          end
        end
      end
      responses
    end
  end
end